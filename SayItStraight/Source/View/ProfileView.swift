//
//  ProfileView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var coordinator: Coordinator
    @State var viewModel: ProfileViewModel
    @State var selection: ProfileOption?
    @Environment(LoginViewModel.self) private var loginViewModel: LoginViewModel

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                List(ProfileOption.allCases, selection: $selection) { option in
                    listOption(for: option)
                }
                .navigationTitle("Profile")
            }
            .navigationBarBackButtonHidden()
            .appSettingsButton {
                coordinator.navigate(to: .settingsView)
            }
            .alert("Are you sure you want to sign out?", isPresented: $viewModel.isSignOutAlertPresented) {
                Button("Sign out") {
                    Task {
                        do {
                            try await viewModel.signOut()
                            loginViewModel.isUserLoggedIn = false
                        } catch {
                            throw error
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    // handle cancel
                }
            }
        }
    }
    
    @ViewBuilder
    func listOption(for option: ProfileOption) -> some View {
        Button {
            option.performAction(using: coordinator, viewModel: viewModel)
        } label: {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: option.imageString)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(option.title)
                    .font(.headline)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView(coordinator: Coordinator(), viewModel: ProfileViewModel(client: nil))
}
