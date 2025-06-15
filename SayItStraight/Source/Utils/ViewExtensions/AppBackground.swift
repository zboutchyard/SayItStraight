//
//  AppBackground.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUICore

struct AppBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image(.background)
                    .resizable()
                    .scaledToFill()
            )
    }
}

extension View {
    public func appBackground() -> some View {
        modifier(AppBackground())
    }
}
