//
//  ContainerView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI
import Supabase

enum Tab {
    case add
    case home
    case profile
}

struct ContainerView: View {
    @State private var selectedTab: Tab = .home
    @Bindable var coordinator: Coordinator
    @Environment(LoginViewModel.self) private var viewModel: LoginViewModel
    @State private var client: SupabaseClient
    
    init(client: SupabaseClient, coordinator: Coordinator) {
        self.client = client
        self.coordinator = coordinator
    }
    
    var body: some View {
        Group {
            NavigationStack(path: $coordinator.path) {
                TabView(selection: $selectedTab) {
                    AddView()
                        .tabItem {
                            Label("Add", systemImage: "plus.app.fill")
                        }
                        .tag(Tab.add)
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(Tab.home)
                    ProfileView(coordinator: coordinator, viewModel: ProfileViewModel(client: client))
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                        .tag(Tab.profile)
                }
                .task {
                    coordinator.reset()
                }
                .navigationBarBackButtonHidden()
                .tint(Color(red: 0.767, green: 0.188, blue: 0.255))
                .environment(coordinator)
                .navigationDestination(for: SayItStraightRoute.self) { route in
                    coordinator.view(for: route)
                }
            }
        }
    }
}
