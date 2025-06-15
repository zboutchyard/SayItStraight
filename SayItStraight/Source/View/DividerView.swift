//
//  DividerView.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import SwiftUICore

struct DividerView: View {
    @State var coordinator: Coordinator = Coordinator()
    @State private var waveOffsetX: CGFloat = -100
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.3))
            Text("or")
                .foregroundColor(.white.opacity(0.6))
                .font(.subheadline)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.3))
        }
    }
}
