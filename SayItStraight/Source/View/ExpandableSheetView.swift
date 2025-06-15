//
//  PullUpSheetScrollView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/11/25.
//

import SwiftUI

struct ExpandableSheetView: View {
    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height * 0.2
    @State private var dragOffset: CGFloat = 0
    private let collapsedHeight: CGFloat = UIScreen.main.bounds.height * 0.25
    private let expandedHeight: CGFloat = 0
    let items: [HomeViewDataItem]
    
    var body: some View {
        ZStack {
            VStack {
                sheetContent
                    .background(Color.white)
                    .cornerRadius(20)
                    .offset(y: max(sheetOffset + dragOffset, expandedHeight))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.height
                            }
                            .onEnded { _ in
                                let shouldExpand: Bool = dragOffset < -50
                                let shouldCollapse: Bool = dragOffset > 50
                                
                                withAnimation(.easeOut) {
                                    if shouldExpand {
                                        sheetOffset = expandedHeight
                                    } else if shouldCollapse {
                                        sheetOffset = collapsedHeight
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
            }
        }
    }
    
    var sheetContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(items, id: \.revieweeName) { item in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 80)
                        .overlay {
                            HStack(alignment: .center) {
                                profileImage(item: item)

                                VStack(alignment: .leading) {
                                    Text(item.revieweeName)
                                        .font(.headline)
                                    Text(item.reviewDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                lieReviewView(item: item)
                            }
                            .padding(.horizontal)
                            
                        }
                }
            }
            .padding()
            .background(
                GeometryReader { geo in
                    Color(.white)
                        .onChange(of: geo.frame(in: .global).minY) { newOffset, _ in
                            if newOffset > 100 {
                                withAnimation {
                                    sheetOffset = collapsedHeight
                                }
                            }
                        }
                }
            )
        }
        .disabled(sheetOffset != expandedHeight) // prevent scroll unless full
    }
    
    @ViewBuilder
    func lieReviewView(item: HomeViewDataItem) -> some View {
        Text("\(Int(item.lieReviewPercentage * 100))% truthfulness")
            .font(.subheadline)
            .foregroundStyle(item.lieReviewPercentage > 0.75 ? .green : .red)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(item.lieReviewPercentage > 0.75 ? .green.opacity(0.2) : .red.opacity(0.2))
            )
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
    }
    
    @ViewBuilder
    func profileImage(item: HomeViewDataItem) -> some View {
        AsyncImage(url: URL(string: item.revieweeImageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .clipped()
    }
}

#Preview {
    let items: [HomeViewDataItem] = [
        HomeViewDataItem(
            lieReviewPercentage: 0.8,
            certaintyPercentage: 0.7,
            revieweeName: "John Doe",
            // swiftlint:disable:next line_length
            revieweeImageURL: "https://media.istockphoto.com/id/1682296067/photo/happy-studio-portrait-or-professional-man-real-estate-agent-or-asian-businessman-smile-for.jpg?s=2048x2048&w=is&k=20&c=4PPfwN_6yoEHwLeYK3S2Pi-Ck6JYEFLvUIrGpAHqpeQ=",
            reviewDate: Date())
        ]
    ExpandableSheetView(items: items)
}
