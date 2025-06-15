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
    @State private var isExpanded: Bool = false
    let user: UserData = UserData(firstName: "Zachary", lastName: "Boutchyard", email: "ZackBoutchyard@gmail.com", user_id: UUID())
        @Environment(Coordinator.self) var coordinator: Coordinator
    
    let items: [HomeViewDataItem] = [
        HomeViewDataItem(
            lieReviewPercentage: 0.4,
            certaintyPercentage: 0.7,
            revieweeName: "John Doe",
            // swiftlint:disable:next line_length
            revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
            reviewDate: Date()),
        HomeViewDataItem(
            lieReviewPercentage: 0.8,
            certaintyPercentage: 0.7,
            revieweeName: "James Doe",
            // swiftlint:disable:next line_length
            revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
            reviewDate: Date()),
        HomeViewDataItem(
            lieReviewPercentage: 0.8,
            certaintyPercentage: 0.7,
            revieweeName: "Hone Doe",
            // swiftlint:disable:next line_length
            revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
            reviewDate: Date()),
        HomeViewDataItem(
            lieReviewPercentage: 0.4,
            certaintyPercentage: 0.7,
            revieweeName: "Ding Doe",
            // swiftlint:disable:next line_length
            revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
            reviewDate: Date())
        ]
    
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
            ExpandableSheetView(items: items)
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
