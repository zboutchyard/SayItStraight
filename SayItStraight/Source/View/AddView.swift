//
//  AddView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI

struct AddView: View {
    @Environment(Coordinator.self) var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .navigationBarBackButtonHidden()
        .appSettingsButton {
            coordinator.navigate(to: .settingsView)
        }
    }
}

#Preview {
    AddView()
}
