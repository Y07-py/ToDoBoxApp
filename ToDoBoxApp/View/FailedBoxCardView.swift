//
//  FailedBoxCardView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/29.
//

import SwiftUI

struct FailedBoxCardView: View {
    
    @ObservedObject var box: FailedBox
    
    var body: some View {
        VStack {
            HStack {
                Text(box.title)
                    .frame(width: 300, height: 80)
                    .lineLimit(2)
                    .font(.title2)
                    .foregroundColor(.black)
                Image("uncheckedbox_2")
                    .offset(x: -10)
            }
        }
    }
}

