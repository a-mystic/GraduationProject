//
//  ContentView.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isFetching = false
    @State private var showRecommendedContent = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ProgressView()
                    .opacity(isFetching ? 1 : 0)
                VStack(spacing: 30) {
                    inputField
                    NavigationLink {
                        ContentRecommender()
                    } label: {
                        Text("Analyze")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background {
                                Color.blue
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showRecommendedContent) {
            ContentRecommender()
        }
    }
    
    @State private var inputs = ""
    
    private var inputField: some View {
        TextEditor(text: $inputs)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .frame(width: 300, height: 300)
            .shadow(radius: 10)
    }
    
    private var analyze: some View {
        Button {
            showRecommendedContent = true
        } label: {
            Text("Analyze")
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContentView()
}
