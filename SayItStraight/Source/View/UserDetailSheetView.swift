//
//  UserDetailSheetView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import SwiftUI

struct UserDetailSheetView: View {
    @Bindable var viewModel: UserViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Let's grab your name")
                    .font(.custom("Fredoka-SemiBold", size: 18))
                    .foregroundColor(.white)) {
                    TextField("",
                              text: $viewModel.firstName,
                              prompt: Text("First name")
                                .foregroundStyle(.white)
                                .font(.custom("Fredoka-SemiBold", size: 16)))
                        .textFieldStyle(AppTextFieldStyle())
                        .autocapitalization(.words)
                    TextField("",
                              text: $viewModel.lastName,
                              prompt: Text("Last name")
                                .foregroundStyle(.white)
                                .font(.custom("Fredoka-SemiBold", size: 16)))
                        .textFieldStyle(AppTextFieldStyle())
                        .autocapitalization(.words)
                }
                Section {
                    Button(action: {
                        Task {
                            try await viewModel.updateUser()
                        }
                    }) {
                        Text("Register")
                            .font(.custom("Fredoka-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.9, green: 0.3, blue: 0.25))
                            .cornerRadius(20)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Complete Profile")
        }
        .interactiveDismissDisabled()
        .appShadow()
        .appBackground()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
