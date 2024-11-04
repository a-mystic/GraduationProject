//
//  ChatBot.swift
//  GraduationProject
//
//  Created by a mystic on 4/9/24.
//

import SwiftUI

struct ChatBot: View {
    @Binding var serverState: ServerState
    
    init(serverState: Binding<ServerState>) {
        _serverState = serverState
    }
    
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
                    if serverState == .bad {
                        Image(systemName: "lock.fill")
                            .scaleEffect(3)
                            .foregroundStyle(.black)
                    }
                }
                sendBar
            }
            .onTapGesture {
                isFocused = false
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
    
    private var placeHolderMessage: String {
        if serverState == .bad {
            return "현재 상태에서는 사용이 불가능해요"
        } else {
            return "메세지를 입력해 주세요"
        }
    }
    
    @FocusState private var isFocused
    
    private var sendBar: some View {
        HStack {
            TextField(placeHolderMessage, text: $enteredText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .disabled(serverState == .bad)
                .onChange(of: enteredText) { value in
                    if let lastCharacter = value.last, lastCharacter.isEmoji {
                        enteredText.removeLast()
                    }
                }
            send
        }
        .padding(.horizontal)
    }
    
    @State private var isFetching = false
    
    private var send: some View {
        Button {
            let text = enteredText
            enteredText = ""
            isFocused = false
            withAnimation {
                if text != "" {
                    messageDatas.append(Chat(message: text, isSender: true))
                    Task(priority: .background) {
                        await fetchAnswer(message: text)
                    }
                }
            }
        } label: {
            Image(systemName: "paperplane.fill")
        }
        .buttonStyle(.borderedProminent)
        .disabled(serverState == .bad)
    }
    
    struct ResponseMessage: Codable {
        var message: String
    }
    
    private func fetchAnswer(message: String) async {
        let url = ServerUrls.chat + "?message=\(message)"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            isFetching = true
            let (data, _) = try await URLSession.shared.data(from: url)
            let responseMessage = try JSONDecoder().decode(ResponseMessage.self, from: data)
            isFetching = false
            messageDatas.append(Chat(message: responseMessage.message, isSender: false))
        } catch {
            serverState = .bad
        }
    }
}

#Preview {
    ChatBot(serverState: .constant(.good))
}
