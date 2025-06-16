//
//  Coordinator.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUI
import Observation
import Supabase

@Observable
class Coordinator {
    var path: NavigationPath = NavigationPath()

    func navigate(to route: SayItStraightRoute) {
        path.append(route)
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func reset() {
        path = NavigationPath()
    }

    @ViewBuilder
    func view(for route: SayItStraightRoute) -> some View {
        switch route {
        case .someOtherView:
            EmptyView()
        case .registerView(let viewModel):
            RegisterView(bindableModel: viewModel)
        case .loginView(let viewModel):
            LoginView(bindableModel: viewModel)
        case .containerView(let client):
            ContainerView(client: client, coordinator: self)
        case .settingsView:
            SettingsView()
        case .practiceView:
            PracticeView()
        case .analysisView:
            EmptyView()
        }
    }
}
