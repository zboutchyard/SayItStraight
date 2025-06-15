//
//  LoginView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(Coordinator.self) var coordinator: Coordinator
    @Bindable var bindableModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if !bindableModel.errors.isEmpty {
                ForEach(bindableModel.errors, id: \.self) { error in
                    VStack {
                        Text(error)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.red)
                }
            }
            appLogoView
            signInWithAppleButton
            signInWithGoogleButton
            DividerView()
            emailPasswordView
            bottomButtonView
        }
        .appShadow()
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground()
        .ignoresSafeArea()
        .appBackButton()
        .hideKeyboardOnTap()
    }
    
    var appLogoView: some View {
        Image(.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 300)
    }
    
    var signInWithGoogleButton: some View {
        Button {
            Task {
                try await bindableModel.signInWithGoogleNative()
                if bindableModel.errors.isEmpty {
                    coordinator.navigate(to: .containerView(coordinator: coordinator))
                }
            }
        } label: {
            HStack {
                Image(.googleLogo)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 5)
                Text("Log in with Google")
                    .font(.custom("Fredoka-SemiBold", size: 18))
            }
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    var signInWithAppleButton: some View {
        Button {
            AppleSignInManager.shared.startSignIn { credential in
                guard let credential = credential else {
                    return
                }
                Task {
                    try await bindableModel.authenticateWithApple(credential: credential)
                    if bindableModel.errors.isEmpty {
                        coordinator.navigate(to: .containerView(coordinator: coordinator))
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "apple.logo")
                    .resizable()
                    .frame(width: 20, height: 24)
                    .padding(.trailing, 5)
                Text("Log in with Apple")
                    .font(.custom("Fredoka-SemiBold", size: 18))
            }
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    var emailPasswordView: some View {
        VStack(spacing: 16) {
            TextField("",
                      text: $bindableModel.email,
                      prompt:
                        Text("Email")
                .foregroundStyle(.white)
                .font(.custom("Fredoka-SemiBold",
                              size: 16))
            )
            .textFieldStyle(AppTextFieldStyle())
            .keyboardType(.emailAddress)
            
            SecureField("",
                        text: $bindableModel.password,
                        prompt:
                            Text("Password")
                .foregroundStyle(.white)
                .font(.custom("Fredoka-SemiBold",
                              size: 16)))
            .textFieldStyle(AppTextFieldStyle())
        }
        .padding(.bottom, 50)
    }
    
    var bottomButtonView: some View {
        VStack {
            Button(action: {
                Task {
                    try await bindableModel.loginUser()
                    if bindableModel.errors.isEmpty {
                        coordinator.navigate(to: .containerView(coordinator: coordinator))
                    }
                }
            }) {
                Text("Log in")
                    .font(.custom("Fredoka-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.3, blue: 0.25))
                    .cornerRadius(20)
            }
        }
    }
}
