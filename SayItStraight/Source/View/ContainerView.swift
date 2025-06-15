//
//  ContainerView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI

enum Tab {
    case add
    case home
    case profile
}

struct ContainerView: View {
    @State private var selectedTab: Tab = .home
    @Bindable var coordinator: Coordinator
    
    var body: some View {
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
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(Tab.profile)
        }
        .navigationBarBackButtonHidden()
        .tint(Color(red: 0.767, green: 0.188, blue: 0.255))
    }
}

#Preview {
    ContainerView(coordinator: Coordinator())
}
