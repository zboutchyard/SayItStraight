//
//  ProfileView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(Coordinator.self) var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Hello world")
        }
        .navigationBarBackButtonHidden()
        .appSettingsButton {
            coordinator.navigate(to: .settingsView)
        }
    }
}

#Preview {
    ProfileView()
}
