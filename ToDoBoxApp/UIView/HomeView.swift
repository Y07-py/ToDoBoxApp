//
//  HomeView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataModel: DBViewModel
    
    @State var ischeck: Bool = false
    @State var boxid: UUID = UUID()
    @State var isdeleted: Bool = false
    @State var showingDetail: Bool = false
    @State var showingAlert: Bool = false
    @State var isNewCard: Bool = false
    @State var page: Int? = 0
    @State var deletebox: UncompltedBox?
    @State var deletevector: [UncompltedBox] = []
    @State var idVector: [UUID] = []
    @State var isdeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                        ForEach(dataModel.uncompboxs) { box in
                            BoxCardView(box: box, boxid: $boxid, deletevector: $deletevector, idVector: $idVector)
                                .onChange(of: [boxid]) { newValue in
                                    if (box.id == boxid) {
                                        dataModel.addCompletedBox(object: box)
                                        dataModel.deleteBox(object: box)
                                    }
                                }
                                .background(Color(SelectBoxColor().convertUIColor(object: box.boxcolor)).opacity(0.6))
                                .cornerRadius(15)
                                .contentShape(RoundedRectangle(cornerRadius: 10))
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        self.isdeleted.toggle()
                                        self.deletebox = box
                                    }) {
                                        Image("trashbox")
                                        Text("Delete Box")
                                            .font(.title3)
                                    }
                                })
                                .gesture(TapGesture().onEnded({ _ in
                                    dataModel.updataBox = box
                                    dataModel.setupInitialBox()
                                    self.showingDetail.toggle()
                                }))
                                .sheet(isPresented: $showingDetail) {
                                    AddBoxCardView(isNewCard: $isNewCard)
                                }
                                .shadow(color: .gray, radius: 15, x: 5, y: 5)
                            
                        }
                        .onChange(of: deletebox) { newValue in
                            dataModel.deleteBox(object: deletebox!)
                        }
                    
                }
            }
            .frame(height: 600)
            .offset(y: 15)
            HStack {
                Button(action: {
                    self.isdeleteAlert.toggle()
                }) {
                    Image("trashbox")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                }
                .frame(width: 70, height: 70)
                .offset(x: 10,y: 0)
                Spacer().alert(isPresented: $isdeleteAlert) {
                    Alert(
                        title: Text("選択されたBoxを削除しますか?"),
                        primaryButton: .default(Text("はい"), action: {
                            dataModel.deleteUnCompBoxs = deletevector
                            for box in self.deletevector {
                                dataModel.uncompboxs.removeAll { $0.id == box.id }
                            }
                            deletevector.removeAll()
                            idVector.removeAll()
                            print(dataModel.deleteUnCompBoxs)
                            dataModel.deleteSelectedUnCompBox()
                        }),
                        secondaryButton: .cancel(Text("いいえ"))
                    )
                }
                NavigationLink(destination: AddBoxCardView(isNewCard: $isNewCard), tag: 1, selection: $page) {
                    EmptyView()
                    Button(action: {
                        self.page = 1
                        self.isNewCard = true
                    }) {
                        Image("add_2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .cornerRadius(70)
                    }
                }
                .shadow(color: .gray, radius: 10, x:5,y:5)
                .position(x: UIScreen.main.bounds.width - 140)
                .offset(y: 45)
            }
        }
        .offset(y: 10)
        .background(Color(red: 0.90, green: 0.94, blue: 1.0, opacity: 0.9))
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .environmentObject(DBViewModel())
    }
}
