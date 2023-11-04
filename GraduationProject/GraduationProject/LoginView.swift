//
//  LoginView.swift
//  GraduationProject
//
//  Created by a mystic on 10/28/23.
//

import SwiftUI
import PhotosUI

struct LoginView: View {
    @Binding var loginIsNeeded: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    selectLoginMode
                    profileImage
                    emailField
                    passwordField
                    createAccount
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color.gray.opacity(0.1))
            .navigationDestination(isPresented: $needMoreData) {
                MoreInfoView(loginIsNeeded: $loginIsNeeded)
            }
        }
        .ignoresSafeArea(.all)
    }
    
    @State private var isLoginMode = false
    
    var selectLoginMode: some View {
        Picker(selection: $isLoginMode) {
            Text("Login")
                .tag(true)
            Text("Create Account")
                .tag(false)
        } label: {
            Text("Picker Here")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @ViewBuilder
    var profileImage: some View {
        if !isLoginMode {
            PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                if selectedImage != nil, let data = selectedImageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 128, height: 128)
                        .scaledToFill()
                        .cornerRadius(64)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                        .foregroundColor(Color(.label))
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 1))
                }
            }
            .onChange(of: selectedImage) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
    
    @State private var email = ""
    
    var emailField: some View {
        TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding(12)
            .background(Color.white)
            .cornerRadius(5)
    }
    
    @State private var password = ""
    
    var passwordField: some View {
        SecureField("PassWord", text: $password)
            .padding(12)
            .background(Color.white)
            .cornerRadius(5)
    }
    
    @State private var needMoreData = false
    
    var createAccount: some View {
        Button {
            if isLoginMode {
                needMoreData = true
                isLoginMode = false
            } else {
                isLoginMode = true
                email = ""
                password = ""
            }
        } label: {
            HStack {
                Spacer()
                Text(isLoginMode ? "LogIn" : "Create Account")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

#Preview {
    LoginView(loginIsNeeded: .constant(true))
}
