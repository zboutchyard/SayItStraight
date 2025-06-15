//
//  RegisterView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(Coordinator.self) var coordinator: Coordinator
    @Bindable var bindableModel: LoginViewModel
    
    var body: some View {
        VStack {
            switch bindableModel.loadingState {
            case .idle, .loaded:
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
                    createAccountHeadline
                    signInWithGoogleButton
                    signInWithAppleButton
                    DividerView()
                    emailPasswordView
                    alreadyHaveAccountView
                    bottomButtonView
                }
                .hideKeyboardOnTap()
            case .loading:
                ProgressView()
            case .error:
                Text("Encountered error during network call")
            }
        }
        .appShadow()
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground()
        .ignoresSafeArea()
        .appBackButton()
    }
    
    var alreadyHaveAccountView: some View {
        HStack {
            Text("Already have an account?")
            Button {
                coordinator.goBack()
            } label: {
                Text("Log in")
                    .underline(true, color: .white)
            }
            
        }
        .foregroundColor(.white.opacity(0.7))
        .font(.custom("Fredoka-SemiBold", size: 16))
    }
    
    var bottomButtonView: some View {
        VStack {
            Button(action: {
                Task {
                    try await bindableModel.createUser()
                    if bindableModel.errors.isEmpty {
                        coordinator.navigate(to: .containerView(coordinator: coordinator))
                    }
                }
            }) {
                Text("Register")
                    .font(.custom("Fredoka-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.3, blue: 0.25))
                    .cornerRadius(20)
            }
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
            SecureField("",
                        text: $bindableModel.confirmPassword,
                        prompt:
                            Text("Confirm Password")
                .foregroundStyle(.white)
                .font(.custom("Fredoka-SemiBold",
                              size: 16)))
            .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    var appLogoView: some View {
        Image(.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 300)
    }
    
    var createAccountHeadline: some View {
        Text("Create your account")
            .font(.custom("Fredoka-SemiBold", size: 24))
            .foregroundColor(.white)
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
                Text("Continue with Google")
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
                Text("Continue with Apple")
                    .font(.custom("Fredoka-SemiBold", size: 18))
            }
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}
