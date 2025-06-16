//
//  SayItStraightApp.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/7/25.
//

import SwiftUI
import Supabase

@main
struct SayItStraightApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var loginViewModel: LoginViewModel
    @State var coordinator: Coordinator = Coordinator()
    @State private var id: UUID = UUID()

    let supabase: SupabaseClient
    

    init() {
        self.supabase = SupabaseClient(
            supabaseURL: URL(
                string:SupabaseInfo.urlString
            )!,
            supabaseKey: SupabaseInfo.publicKeyString)
        _loginViewModel = State(wrappedValue: LoginViewModel(supabase: self.supabase))
        AppDelegate.supabase = supabase
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 0.994, green: 0.533, blue: 0.452, alpha: 1)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                VStack {
                    if loginViewModel.isUserLoggedIn {
                        ContainerView(client: supabase, coordinator: coordinator)
                    } else {
                        LandingView(coordinator: coordinator)
                    }
                }
                .id(id)
                .task {
                    _ = try? await loginViewModel.getSession()
                }
            }
            .environment(loginViewModel)
            .environment(\.font, .custom("Fredoka-SemiBold", size: 16))
            .environment(coordinator)
        }
    }
}

extension UIApplication {
    static var topViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }

        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
