//
//  ProfileViewModel.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/15/25.
//

import Foundation
import Supabase

@Observable
class ProfileViewModel {
    var client: SupabaseClient?
    var isSignOutAlertPresented: Bool = false
    
    init(client: SupabaseClient? = nil) {
        self.client = client
    }
    
    func signOut() async throws {
        do {
            try await client?.auth.signOut()
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error)")
            throw error
        }
    }
}
