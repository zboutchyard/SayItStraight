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
        ZStack(alignment: .top) {
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200)
                .zIndex(1)
                .appShadow()
            VStack(alignment: .center) {
                Button {
                    // add button action
                } label: {
                    Image(systemName: "video.badge.plus.fill")
                        .resizable()
                        .foregroundStyle(Color(hue: 0.021, saturation: 0.115, brightness: 0.869))
                        .scaledToFit()
                        .padding()
                }
                .frame(width: 300, height: 200)
                .appShadow()
                .buttonStyle(.plain)
                Text("Begin your truth analysis.")
                    .font(.custom("Fredoka-SemiBold", size: 24))
                    .foregroundStyle(.white)
                    .appShadow()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .appBackground()
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .appSettingsButton {
            coordinator.navigate(to: .settingsView)
        }
    }
}

#Preview {
    AddView()
        .environment(Coordinator())
}
