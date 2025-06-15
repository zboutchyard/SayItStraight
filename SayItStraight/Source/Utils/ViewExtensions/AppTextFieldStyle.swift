//
//  AppTextField.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import SwiftUICore
import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 0.925, green: 0.395, blue: 0.296))
            .cornerRadius(20)
            .foregroundStyle(.white)
    }
}
