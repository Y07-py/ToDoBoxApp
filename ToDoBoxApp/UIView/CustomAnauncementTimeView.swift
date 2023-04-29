//
//  CustomAnauncementTimeView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/25.
//

import SwiftUI

struct CustomAnauncementTimeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedValue: Int = 1
    @State var isdecide: Bool = false
    
    @Binding var num: String
    @Binding var selectedValue_2: Int
    @Binding var customtime: String
    @Binding var selectedIndex: Int
    @Binding var timearray: [String]
    @Binding var uuid: UUID
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("", text: $num)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    .pickerStyle(.wheel)
                    Picker("", selection: $selectedValue_2) {
                        Text("分前").tag(0)
                        Text("時間前").tag(1)
                        Text("日前").tag(2)
                    }
                    .pickerStyle(.wheel)
                }
            }
            Section {
                Button(action: {
                    self.isdecide.toggle()
                    dismiss()
                }) {
                    HStack {
                        Spacer()
                        Text("決定")
                        Spacer()
                    }
                }
            }
        }
        .onDisappear {
            guard let number = Int(num) else { return }
            
            if (isdecide) {
                if (selectedValue_2 == 0) {
                    let hour = number / 60
                    let minuts = number % 60
                    if (hour > 0) {
                        self.customtime = "\(hour)時間\(minuts)分前"
                    }
                    else {
                        self.customtime = "\(minuts)分前"
                    }
                }
                else if (selectedValue_2 == 1) {
                    self.customtime = "\(String(num))時間前"
                }
                else if (selectedValue_2 == 2) {
                    self.customtime = "\(String(num))日前"
                }
                self.selectedIndex = 5
            }
            else {
                self.selectedIndex = 0
            }
            if (self.timearray.count == 5) {
                if (self.isdecide) {
                    self.timearray.insert(self.customtime, at: 5)
                }
            }
            else {
                self.timearray.popLast()
                self.timearray.insert(self.customtime, at: 5)
            }
            self.uuid = UUID()
        }
    }
}

