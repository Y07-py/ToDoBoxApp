//
//  BoxCardView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/23.
//

import SwiftUI

struct BoxCardView: View {
    
    @ObservedObject var box: UncompltedBox
    
    @State var showingAlert: Bool = false
    @State var ischeck: Bool = false
    @State var showingAlert_2: Bool = false
    @State var isdelete: Bool = false
    @State var iscircle: Bool = false
    
    @Binding var boxid: UUID
    @Binding var deletevector: [UncompltedBox]
    @Binding var idVector: [UUID]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.iscircle.toggle()
                    if (self.iscircle) {
                        if self.deletevector.count == 0 {
                            self.deletevector.append(box)
                            self.idVector.append(box.id)
                        }
                        else {
                            let iscontain = self.idVector.contains { $0 == box.id }
                            if (!iscontain) {
                                self.deletevector.append(box)
                                self.idVector.append(box.id)
                            }
                        }
                    }
                    else {
                        self.deletevector.removeAll { $0.id == box.id }
                        self.idVector.removeAll { $0 == box.id }
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                        Circle()
                            .foregroundColor(self.iscircle ? Color.green : Color.white)
                            .frame(width: 15, height: 15)
                    }
                }
                .offset(x: 10)
                VStack(spacing: 5) {
                    Text(box.title)
                        .frame(width: 300, height: 80)
                        .lineLimit(2)
                        .font(.title2)
                        .offset(y: 20)
                    Text(dateTransformToJP(object: box.deadline) + (box.deadline == nil ? "" : "まで"))
                        .frame(width: 300, height: 40)
                        .font(.title3)
                    
                }
                Button(action: {
                    self.showingAlert = true
                    self.ischeck = true
                }) {
                    if (self.ischeck) {
                        Image("checkedbox_2")
                    }
                    else {
                        Image("uncheckedbox_2")
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert.init(title: Text("このBoxを完了にしますか？"),
                               primaryButton: .destructive(Text("No"),
                                                           action: {
                        self.ischeck = false
                    }),
                               secondaryButton: .cancel(Text("Yes"),
                                                        action: {
                        self.boxid = box.id
                    }))
                }
                .offset(x: -10)
            }
        }
    }
    
    func dateTransformToJP(object: Date?) -> String {
        guard let object = object else { return "期限なし"}
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .short
        return dateformatter.string(from: object)
    }
}
