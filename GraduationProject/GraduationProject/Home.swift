//
//  Home.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

struct Home: View {
    @State private var isFetching = false
    @State private var showDescription = false
    @State private var showRecommendedContent = false
    
    @State private var loginIsNeed = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .opacity(0.1)
                    .ignoresSafeArea(edges: .bottom)
                    .onTapGesture {
                        isFocused = false
                        currentStatus = .isNotRecording
                    }
                VStack(spacing: 30) {
                    recordingStatus
                    inputField
                    analyze
                    Spacer()
                        .frame(width: 0, height: 40)
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
        .sheet(isPresented: $loginIsNeed) {
            LoginView(loginIsNeeded: $loginIsNeed)
        }
    }
    
    @State private var inputs = ""
    
    @FocusState private var isFocused: Bool
    
    private var inputField: some View {
        TextEditor(text: $inputs)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .frame(width: 300, height: 300)
            .shadow(radius: 10)
            .focused($isFocused)
            .onTapGesture {
                currentStatus = .isRecording
            }
    }
    
    private var analyze: some View {
        Button("Analyze") {
            isFetching = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                showRecommendedContent = true
                isFetching = false
                currentStatus = .isNotRecording
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    @State private var currentStatus = RecordingStatus.isNotRecording
    
    private enum RecordingStatus: String {
        case isRecording = "감정을 분석하고 있습니다."
        case isNotRecording = "감정을 분석하고 있지 않습니다."
    }
    
    private var recordingStatus: some View {
        HStack {
            Image(systemName: "face.smiling.inverse")
            Text(currentStatus.rawValue)
        }
            .foregroundStyle(.secondary)
            .font(.callout)
    }
}

#Preview {
    Home()
}
