//
//  HideKeyboardOnTap.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUICore
import UIKit

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}
