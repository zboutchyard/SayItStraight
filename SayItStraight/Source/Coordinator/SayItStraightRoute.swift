//
//  SayItStraightRoute.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import SwiftUI
import Supabase

enum SayItStraightRoute: Hashable {
    static func == (lhs: SayItStraightRoute, rhs: SayItStraightRoute) -> Bool {
           switch (lhs, rhs) {
           case (.registerView, .registerView):
               return true
           default: return lhs.hashValue == rhs.hashValue
           }
       }
       
       func hash(into hasher: inout Hasher) {
           switch self {
           case .registerView:
               hasher.combine("monthlyBudgetInputView")
           default:
               hasher.combine("some other value")
           }
       }
    
    case someOtherView
    case registerView(viewModel: LoginViewModel)
    case loginView(viewModel: LoginViewModel)
    case containerView(coordinator: Coordinator)
    case settingsView
    case practiceView
    case analysisView
}
