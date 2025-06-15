//
//  UserViewModel.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import Supabase

struct UserData: Codable {
    var firstName: String?
    var lastName: String?
    var email: String
    var user_id: UUID
}

@Observable
class UserViewModel {
    var supabase: SupabaseClient
    var user: UserData?
    var appState: AppState = .idle
    var userNotFound: Bool = false
    var shouldShowRegistrationSheet: Bool = false
    var firstName: String = ""
    var lastName: String = ""
    var errors: [String] = []
    
    init() {
        self.supabase = .init(
            supabaseURL: URL(
                string: SupabaseInfo.urlString)!,
            supabaseKey: SupabaseInfo.publicKeyString
        )
    }
    
    func signOut() async throws {
        do {
            try await supabase.auth.signOut()
        } catch {
            errors.append("Unable to sign out, please try again.")
        }
    }
    
    func getUserByID() async throws {
        appState = .loading
        let userId: UUID = try await supabase.auth.session.user.id
        do {
            self.user = try await supabase.from("users")
                .select("*")
                .eq("user_id", value: userId)
                .single()
                .execute()
                .value
            appState = .loaded
            if user?.firstName?.isEmpty == true || user?.lastName?.isEmpty == true {
                shouldShowRegistrationSheet = true
            }
        } catch {
            userNotFound = true
            appState = .error
        }
    }
    
    func updateUser() async throws {
        do {
            let userId: UUID = try await supabase.auth.session.user.id
            let result: PostgrestResponse = try await supabase.from("users")
                .update(["firstName": firstName, "lastName": lastName])
                .eq("user_id", value: userId)
                .execute()
            debugPrint(result)
        } catch {
            print("Insert failed: \(error.localizedDescription)")
        }
    }
}
