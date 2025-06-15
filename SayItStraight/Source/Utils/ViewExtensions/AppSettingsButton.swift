//
//  GearToolbarModifier.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/11/25.
//

import SwiftUICore
import SwiftUI

struct AppSettingsButton: ViewModifier {
    var action: () -> Void = {}

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: action) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                }
            }
    }
}

extension View {
    func appSettingsButton(action: @escaping () -> Void = {}) -> some View {
        self.modifier(AppSettingsButton(action: action))
    }
}
