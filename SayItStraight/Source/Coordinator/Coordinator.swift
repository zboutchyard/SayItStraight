//
//  Coordinator.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class Coordinator {
    var path: NavigationPath = NavigationPath()
    var isSignedOut: Bool = false

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

    @ViewBuilder
    func view(for route: SayItStraightRoute) -> some View {
        switch route {
        case .someOtherView:
            EmptyView()
        case .registerView(let viewModel):
            RegisterView(bindableModel: viewModel)
        case .loginView(let viewModel):
            LoginView(bindableModel: viewModel)
        case .containerView(let coordinator):
            ContainerView(coordinator: coordinator)
        case .settingsView:
            SettingsView()
        case .practiceView:
            EmptyView()
        case .analysisView:
            EmptyView()
        }
    }
}
