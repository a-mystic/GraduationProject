//
//  ContentView.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isFetching = false
    @State private var showDescription = false
    @State private var showRecommendedContent = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 30) {
                    inputField
                    Button("Analyze") {
                        isFetching = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                            showRecommendedContent = true
                            isFetching = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                        .frame(height: 50)
                }
                ProgressView()
                    .scaleEffect(2)
                    .opacity(isFetching ? 1 : 0)
            }
            .navigationDestination(isPresented: $showRecommendedContent) {
                ContentRecommender()
            }
            .navigationTitle("Snooze")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDescription = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showDescription) {
            Description()
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
}

#Preview {
    ContentView()
}
