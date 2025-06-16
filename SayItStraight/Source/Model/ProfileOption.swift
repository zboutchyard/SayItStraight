//
//  ProfileOption.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/15/25.
//

enum ProfileOption: CaseIterable, Identifiable {
    case accountSettings
    case privacy
    case signOut

    var id: String { title }

    var title: String {
        switch self {
        case .accountSettings: return "Account Settings"
        case .privacy: return "Privacy"
        case .signOut: return "Sign Out"
        }
    }
    
    var imageString: String {
        switch self {
        case .accountSettings: return "gear"
        case .privacy: return "lock.shield"
        case .signOut: return "arrow.right.square"
        }
    }

    var description: String? {
        switch self {
        case .accountSettings: return "Update your email, password, and more"
        case .privacy: return "Manage your privacy preferences"
        case .signOut: return nil
        }
    }

    func performAction(using coordinator: Coordinator, viewModel: ProfileViewModel) {
        switch self {
        case .accountSettings:
            coordinator.navigate(to: .settingsView)
        case .privacy:
            print("Navigate to Privacy")
        case .signOut:
            viewModel.isSignOutAlertPresented = true
        }
    }
}
