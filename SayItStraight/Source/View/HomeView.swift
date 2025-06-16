//
//  HomeView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import SwiftUI
import Foundation
import Supabase

struct HomeView: View {
    @State var viewModel: UserViewModel = .init()
    let user: UserData = UserData(
        firstName: "Zachary",
        lastName: "Boutchyard",
        email: "ZackBoutchyard@gmail.com",
        user_id: UUID(),
        fullName: "Zachary Boutchyard"
    )
        @Environment(Coordinator.self) var coordinator: Coordinator
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button {
                    coordinator.navigate(to: .practiceView)
                } label: {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(width: 175, height: 100)
                            .overlay {
                                HStack(spacing: 3) {
                                    Image(systemName: "microphone.fill")
                                    Text("Practice")
                                }
                            }
                    }
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    coordinator.navigate(to: .analysisView)
                } label: {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(width: 175, height: 100)
                            .overlay {
                                HStack(spacing: 3) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                    Text("Analysis")
                                }
                            }
                    }
                }
                .buttonStyle(.plain)
            }
            .appShadow()
            .padding()
            .padding(.top, 20)
            ExpandableSheetView(viewModel: viewModel)
                .zIndex(1)
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.container, edges: .top)
        })
        .appShadow()
    }
}
#Preview {
    HomeView()
        .environment(Coordinator())
}

struct HomeViewDataItem {
    let lieReviewPercentage: Double
    let certaintyPercentage: Double
    let revieweeName: String
    let revieweeImageURL: String
    let reviewDate: Date
}
