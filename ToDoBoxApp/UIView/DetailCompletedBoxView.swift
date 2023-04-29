//
//  DetailCompletedBoxView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/25.
//

import SwiftUI

struct DetailCompletedBoxView: View {
    @ObservedObject var box: CompletedBox
    
    var body: some View {
        VStack {
            HStack {
                Text("メモ")
                    .font(.title2)
                    .offset(x: 30)
                Spacer()
            }
            ScrollView {
                Text(box.content)
                    .padding()
                    .font(.title3)
                    .frame(width: UIScreen.main.bounds.width - 30,height: 300)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            HStack {
                Text("期限日")
                Text(datetoString(object:box.deadline))
                    .padding()
                    .font(.title3)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .offset(y:-300)
            Spacer()
        }.navigationTitle(Text(box.title).font(.largeTitle))
            .background(Color.gray.opacity(0.2))
    }
    
    func datetoString(object: Date?) -> String {
        guard let object = object else { return "期限なし"}
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let stringDate = dateFormatter.string(from: object)
        
        return stringDate
    }
}

