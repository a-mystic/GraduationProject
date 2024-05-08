//
//  ChatBot.swift
//  GraduationProject
//
//  Created by a mystic on 4/9/24.
//

import SwiftUI

struct ChatBot: View {
    @State private var messageDatas = [Chat]()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ScrollViewReader { reader in
                        messages
                        HStack {
                            Spacer()
                        }
                        .onChange(of: messageDatas) { _ in
                            if let lastId = messageDatas.last?.id {
                                reader.scrollTo(lastId, anchor: .top)
                            }
                        }
                    }
                }
                .background(.gray.opacity(0.1))
                .overlay {
                    if isFetching {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.gray)
                    }
                }
                sendBar
            }
            .navigationTitle("심리상담")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var messages: some View {
        ForEach(messageDatas) { message in
            HStack {
                if message.isSender {
                    Spacer()
                }
                Text(message.message)
                    .foregroundStyle(.white)
                    .padding()
                    .background(message.isSender ? .blue.opacity(0.75) : .brown.opacity(0.75), in: RoundedRectangle(cornerRadius: 8))
                if !message.isSender {
                    Spacer()
                        .frame(width: 100)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
    
    @State private var enteredText = ""
    
    private var sendBar: some View {
        HStack {
            TextField("Message", text: $enteredText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            send
        }
        .padding(.horizontal)
    }
    
    @State private var isFetching = false
    
    private var send: some View {
        Button {
            let text = enteredText
            enteredText = ""
            withAnimation {
                messageDatas.append(Chat(message: text, isSender: true))
                Task(priority: .background) {
                    await fetchAnswer(message: text)
                }
            }
        } label: {
            Image(systemName: "paperplane.fill")
        }
        .buttonStyle(.borderedProminent)
    }
    
    struct ResponseMessage: Codable {
        var message: String
    }
    
    private func fetchAnswer(message: String) async {
        let url = ServerUrls.chat + "/chat?message=\(message)"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            isFetching = true
            let (data, _) = try await URLSession.shared.data(from: url)
            let responseMessage = try JSONDecoder().decode(ResponseMessage.self, from: data)
            isFetching = false
            messageDatas.append(Chat(message: responseMessage.message, isSender: false))
        } catch {
            print(error)
        }
    }
}

#Preview {
    ChatBot()
}
