//
//  LoginViewModel.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import Supabase
import AuthenticationServices
import GoogleSignIn
import SwiftUI

enum AppState {
    case loading
    case idle
    case loaded
    case error
}

@Observable
class LoginViewModel {
    var loadingState: AppState = .idle
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errors: [String] = []
    var isUserLoggedIn: Bool = false
    var user: UserData?
    
    let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    @MainActor
    func checkUserLoggedIn() async {
        do {
            let _: Session = try await supabase.auth.session
            self.isUserLoggedIn = true
        } catch {
            self.isUserLoggedIn = false
        }
    }
    
    func createUser() async throws {
        loadingState = .loading
        validateUser()
        if errors.isEmpty {
            do {
                try await supabase.auth.signUp(email: email, password: password)
                try await checkUserExistanceAndCreate()
                loadingState = .loaded
            } catch {
                errors.append("Failed to create user. Please try again later.")
            }
        }
    }
    
    func loginUser() async throws {
        errors.removeAll()
        loadingState = .loading
        do {
            try await supabase.auth.signIn(email: email, password: password)
            loadingState = .loaded
        } catch {
            loadingState = .loaded
            errors.append("Username or password is incorrect. Please try again.")
        }
    }
    
    func validateUser() {
        self.errors.removeAll()
        self.errors = RegistrationValidator.validate(
            username: email,
            password: password,
            confirmPassword: confirmPassword)
    }
    
    fileprivate func checkUserExistanceAndCreate(_ credential: ASAuthorizationAppleIDCredential? = nil,
                                                 googleUser: GIDGoogleUser? = nil) async throws {
        let userID: UUID = try await supabase.auth.session.user.id
        var firstName: String = ""
        var lastName: String = ""
        
        if credential != nil {
            firstName = credential?.fullName?.givenName ?? ""
            lastName = credential?.fullName?.familyName ?? ""
            email = credential?.email ?? ""
        } else if googleUser != nil {
            firstName = googleUser?.profile?.givenName ?? ""
            lastName = googleUser?.profile?.familyName ?? ""
            email = googleUser?.profile?.email ?? ""
        }
        
        do {
            let response: PostgrestResponse<[UserData]> = try await supabase.from("users")
                .select()
                .eq("user_id", value: userID)
                .execute()
            user = UserData(
                firstName: firstName,
                lastName: lastName,
                email: email,
                user_id: userID
            )
            if response.data.isEmpty {
                try await addUser()
            }
        } catch {
            print("User fetch error: \(error)")
            errors.append("Failed to fetch user data.")
        }
    }
    
    @MainActor
    func signInWithGoogleNative() async throws {
        errors.removeAll()
        loadingState = .loading
        guard let rootViewController = UIApplication.topViewController else {
            throw NSError(domain: "MissingRootVC", code: 0)
        }
        
        // Present the Google sign-in screen
        let result: GIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            return
        }
        let accessToken: String = result.user.accessToken.tokenString
        do {
            try await supabase.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken,
                    accessToken: accessToken
                )
            )
            try await checkUserExistanceAndCreate(googleUser: result.user)
        } catch {
            errors.append("Failed to register, please try again.")
        }
        loadingState = .loaded
    }
    
    func authenticateWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        errors.removeAll()
        loadingState = .loading
        
        guard let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            errors.append("Unable to get Apple identity token.")
            loadingState = .error
            return
        }
        
        do {
            let _: Session = try await supabase.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple, idToken: token
                ))
            
            try await checkUserExistanceAndCreate(credential)
        } catch {
            errors.append("Failed to register, please try again.")
        }
        loadingState = .loaded
    }
    
    func addUser() async throws {
        do {
            _ = try await supabase.from("users").insert(user).execute()
        } catch {
            print("Insert failed: \(error.localizedDescription)")
        }
    }
}
