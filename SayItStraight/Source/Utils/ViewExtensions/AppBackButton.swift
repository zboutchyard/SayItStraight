//
//  AppBackButton.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUICore
import SwiftUI

struct AppBackButton: ViewModifier {
    @Environment(Coordinator.self) var coordinator: Coordinator
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        coordinator.goBack()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.white)
                    }
                }
            }
            .navigationBarBackButtonHidden()
    }
}

extension View {
    public func appBackButton() -> some View {
        modifier(AppBackButton())
    }
}
