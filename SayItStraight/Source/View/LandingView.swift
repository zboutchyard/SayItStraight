//
//  ContentView.swift
//  Say It Straight
//
//  Created by Zack Boutchyard on 6/6/25.
//

import SwiftUI

struct LandingView: View {
    @State private var waveOffsetX: CGFloat = -100
    @Bindable var coordinator: Coordinator
    @Environment(LoginViewModel.self) private var viewModel: LoginViewModel

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(alignment: .center) {
                logoView
                subHeadingView
                Spacer()
                buttonView
            }
            .appShadow()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appBackground()
            .ignoresSafeArea()
            .navigationDestination(for: SayItStraightRoute.self) { route in
                coordinator.view(for: route)
            }
        }
    }

    func performSideBounce(iteration: Double) {
        let maxIterations: Double = 6.0
        guard iteration < maxIterations else {
            withAnimation(.easeOut(duration: 0.2)) {
                waveOffsetX = 0
            }
            return
        }

        let amplitude: CGFloat = CGFloat(30 - (iteration * 5)) // Reduce amplitude over time
        let duration: Double = 0.2

        withAnimation(.easeInOut(duration: duration)) {
            waveOffsetX = amplitude
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: duration)) {
                waveOffsetX = -amplitude
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                performSideBounce(iteration: iteration + 1.5)
            }
        }
    }

    var logoView: some View {
        VStack {
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .offset(x: waveOffsetX)
                .onAppear {
                    performSideBounce(iteration: 0)
                }
        }
        .padding(.top, 250)
    }
    
    var subHeadingView: some View {
        Text("Can you pass the test?")
            .font(.custom("Fredoka-SemiBold", size: 24))
            .foregroundColor(.white)
            .padding(.bottom, 20)
    }
    
    var buttonView: some View {
        HStack(spacing: 20) {
            Button(action: {
                coordinator.navigate(to: .loginView(viewModel: viewModel))
            }) {
                Text("Log In")
                    .font(.custom("Fredoka-SemiBold", size: 24))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color(red: 0.932, green: 0.321, blue: 0.254))
                    .cornerRadius(30)
            }
            
            Button(action: {
                coordinator.navigate(to: .registerView(viewModel: viewModel))
            }) {
                Text("Register")
                    .font(.custom("Fredoka-SemiBold", size: 24))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color(red: 0.767, green: 0.188, blue: 0.255))
                    .cornerRadius(30)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 60)
    }
}
