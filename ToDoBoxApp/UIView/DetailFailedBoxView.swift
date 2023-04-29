//
//  DetailFailedBoxView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/29.
//

import SwiftUI

struct DetailFailedBoxView: View {
    
    @ObservedObject var box: FailedBox
    
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
                Text(dateToString(object: box.deadline))
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
    
    func dateToString(object: Date?) -> String {
        guard let object = object else { return "期限なし" }
        let dateformatter = DateFormatter()
        dateformatter.calendar = Calendar(identifier: .gregorian)
        dateformatter.dateFormat = "yyyy年MM月dd日"
        dateformatter.locale = Locale(identifier: "ja_JP")
        let stringDate = dateformatter.string(from: object)
        return stringDate
    }
}


