//
//  TopTabView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import SwiftUI

struct TopTabView: View {
    let list: [String]
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< list.count, id: \.self) { row in
                Button(action: {
                    withAnimation {
                        selectedTab = row
                    }
                }) {
                    VStack(spacing: 0) {
                        HStack {
                            Image(list[row])
                                .foregroundColor(Color.primary)
                        }
                        .frame(width: (UIScreen.main.bounds.width / CGFloat(list.count)),
                               height: 48 - 3)
                        Rectangle()
                            .fill(selectedTab == row ? Color.green : Color.clear)
                            .frame(height: 3)
                    }.fixedSize()
                }
            }
        }
        .frame(height: 48)
        .background(Color.white)
        .compositingGroup()
        .shadow(color: .primary.opacity(0.2), radius: 3, x: 4, y: 4)
    }
}


