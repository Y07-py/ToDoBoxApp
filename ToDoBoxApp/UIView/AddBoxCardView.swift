//
//  AddBoxCardView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import SwiftUI

struct AddBoxCardView: View {
    
    @EnvironmentObject var modelData: DBViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var keyborad = KeyboardHandler()
    
    @State var selectDate: Date = Date()
    @State var boxcolor: String = "red"
    @State var custometime: String = ""
    @State private var selectedIndex: Int = 0
    @State private var customanaunce: Bool = false
    @State private var deadline: String?
    @State private var uuid: UUID = UUID()
    @State private var timeaarray: [String] = ["1時間前", "2時間前", "１日前", "2日前", "カスタム", "期限なし"]
    @State var selectedValue_2: Int = 0
    @State var num: String = "1"
    @State var timeanaunce: String = ""
    
    @Binding var isNewCard: Bool
    
    let notification = NotificationHandler()
    
    
    var textFieldisValid: Bool {
        return !modelData.title.isEmpty
    }
    
    var body: some View {
        
        Form {
            Section(header: Text("タイトル")) {
                TextField("", text: $modelData.title)
                    .frame(height: 30)
            }
            Section(header: Text("メモ")) {
                TextField("", text: $modelData.content, axis: .vertical)
                    .frame(height: 100)
            }
            Section(header: Text("期限の設定")) {
                DatePicker("期限",
                           selection: $selectDate,
                           in: Date()...,
                           displayedComponents: [.hourAndMinute, .date])
            }
            Section(header: Text("通知の設定")) {
                Picker(selection: $selectedIndex, label: Text("通知のタイミング")) {
                    ForEach(0 ..< timeaarray.count, id: \.self) { id in
                        Text(self.timeaarray[id]).tag(self.timeaarray[id])
                    }
                }
                .id(self.uuid)
                .onChange(of: selectedIndex, perform: { newValue in
                    if (selectedIndex == 4) {
                        self.customanaunce.toggle()
                    }
                })
                .sheet(isPresented: $customanaunce) {
                    CustomAnauncementTimeView(num: $num, selectedValue_2: $selectedValue_2, customtime: $custometime, selectedIndex: $selectedIndex, timearray: $timeaarray, uuid: $uuid)
                }
            }
            Section(header: Text("現在のBoxの色")) {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(SelectBoxColor().convertUIColor(object: modelData.boxcolor)).opacity(0.7))
            }
            Section(header: Text("Boxの色の指定")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(SelectBoxColor().boxcolors, id: \.self) { color in
                            Button(action: {
                                self.boxcolor = color
                                modelData.boxcolor = color
                            }) {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(SelectBoxColor().convertUIColor(object: color)).opacity(0.7))
                            }
                        }
                    }
                }
            }
            Button(action: {
                let dateFormatter = DateFormatter()
                
                if (selectedIndex == 0) {
                    guard let modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: selectDate) else { return }
                    modelData.anauncetime = modifiedDate
                    modelData.timeinterval = 60 * 60
                    self.timeanaunce = "１時間"
                }
                else if (selectedIndex == 1) {
                    guard let modifiedDate = Calendar.current.date(byAdding: .hour, value: -2, to: selectDate) else { return }
                    modelData.anauncetime = modifiedDate
                    modelData.timeinterval = 60 * 60 * 2
                    self.timeanaunce = "2時間"
                }
                else if (selectedIndex == 2) {
                    guard let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectDate) else { return }
                    modelData.anauncetime = modifiedDate
                    modelData.timeinterval = 60 * 60 * 24
                    self.timeanaunce = "1日"
                }
                else if (selectedIndex == 3) {
                    guard let modifiedDate = Calendar.current.date(byAdding: .day, value: -2,to: selectDate) else { return }
                    modelData.anauncetime = modifiedDate
                    modelData.timeinterval = 60 * 60 * 24 * 2
                    self.timeanaunce = "２日"
                }
                else if (selectedIndex == 4) {
                    self.customanaunce.toggle()
                }
                else if (selectedIndex == 5) {
                    if (selectedValue_2 == 0) {
                        guard let modifiedDate = Calendar.current.date(byAdding: .minute, value: -Int(num)!, to: selectDate) else { return }
                        modelData.anauncetime = modifiedDate
                        modelData.timeinterval = 60 * Double(num)!
                        self.timeanaunce = "\(Int(num)!)分"
                    }
                    else if (selectedValue_2 == 1) {
                        guard let modifiedDate = Calendar.current.date(byAdding: .hour, value: -Int(num)!, to: selectDate) else { return }
                        modelData.anauncetime = modifiedDate
                        modelData.timeinterval = 60 * 60 * Double(num)!
                        self.timeanaunce = "\(Int(num)!)時間"
                    }
                    else if (selectedValue_2 == 2) {
                        guard let modifiedDate = Calendar.current.date(bySetting: .day, value: -Int(num)!, of: selectDate) else { return }
                        modelData.anauncetime = modifiedDate
                        modelData.timeinterval = 60 * 60 * 24 * Double(num)!
                        self.timeanaunce = "\(Int(num)!)日"
                    }
                }
                else if (selectedIndex == 6) {
                    modelData.deadline = nil
                    self.timeanaunce = "期限なし"
                }
                
                if selectedIndex < 5 {
                    modelData.deadline = selectDate
                }
                else {
                    modelData.isdeadline = false
                }
                self.modelData.addBox()
                self.notification.sendNotification(date: modelData.deadline!, type: "time", timeInterval: modelData.timeinterval,title: "お知らせ", body: "\(modelData.title) の期限まで残り\(self.timeanaunce)です")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text(modelData.updataBox == nil ? "追加": "変更")
                    Spacer()
                }
            }
            .disabled(!self.textFieldisValid)
        }
        .onAppear {
            if (self.isNewCard) {
                modelData.deinitBox()
            }
            self.keyborad.startHandler()
        }.onDisappear {
            self.isNewCard = false
            self.keyborad.stopHandler()
        }
        .padding(.bottom, keyborad.keyboardHeight)
        .animation(.easeOut)
    }
}
