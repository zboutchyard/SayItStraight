//
//  UserViewModel.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Combine
import Foundation
import Supabase

struct UserData: Codable {
    var firstName: String?
    var lastName: String?
    var email: String
    var user_id: UUID
    var fullName: String
}

struct SearchUserData: Codable {
    var firstName: String?
    var lastName: String?
    var user_id: UUID
    var photoURL: String?
    var fullName: String?
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
    let items: [HomeViewDataItem]
    var searchedUsers: [SearchUserData] = []
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        self.supabase = .init(
            supabaseURL: URL(
                string: SupabaseInfo.urlString)!,
            supabaseKey: SupabaseInfo.publicKeyString
        )
        self.items = [
            HomeViewDataItem(
                lieReviewPercentage: 0.4,
                certaintyPercentage: 0.7,
                revieweeName: "John Doe",
                // swiftlint:disable:next line_length
                revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
                reviewDate: Date()),
            HomeViewDataItem(
                lieReviewPercentage: 0.8,
                certaintyPercentage: 0.7,
                revieweeName: "James Doe",
                // swiftlint:disable:next line_length
                revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
                reviewDate: Date()),
            HomeViewDataItem(
                lieReviewPercentage: 0.8,
                certaintyPercentage: 0.7,
                revieweeName: "Hone Doe",
                // swiftlint:disable:next line_length
                revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
                reviewDate: Date()),
            HomeViewDataItem(
                lieReviewPercentage: 0.4,
                certaintyPercentage: 0.7,
                revieweeName: "Ding Doe",
                // swiftlint:disable:next line_length
                revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
                reviewDate: Date())
        ]
    }
    
    func signOut() async throws {
        do {
            try await supabase.auth.signOut()
        } catch {
            errors.append("Unable to sign out, please try again.")
        }
    }
    
    func performSearch(searchText: String) async throws {
        guard searchText.count >= 2 else {
            searchedUsers = []
            return
        }
        do {
            let escaped: String = searchText.replacingOccurrences(of: " ", with: "%")
            let pattern: String = "%\(escaped)%"
            let result: [SearchUserData] = try await supabase.from("users")
                .select()
                .ilike("fullName", pattern: pattern)
                .limit(50)
                .execute()
                .value

            let filtered: [SearchUserData] = result.filter {
                let fullName: String = "\($0.firstName ?? "") \($0.lastName ?? "")"
                return fullName.lowercased().contains(searchText.lowercased())
            }

            searchedUsers = filtered
        } catch {
            print("Search failed: \(error.localizedDescription)")
            throw error
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
