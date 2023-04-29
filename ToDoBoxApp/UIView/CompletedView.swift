//
//  CompletedView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import SwiftUI

struct CompletedView: View {
    @EnvironmentObject var modelData: DBViewModel
    
    @State var isNewCard: Bool = false
    @State var isdeleted: Bool = false
    @State var compbox: CompletedBox?
    @State var deletevector: [CompletedBox] = []
    @State var idVector: [UUID] = []
    @State var isdeletebox: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(modelData.compboxs) { box in
                        NavigationLink(destination:
                            DetailCompletedBoxView(box: box)) {
                            CompletedBoxCardView(box: box, deletevector: $deletevector, idVector: $idVector)
                                    .background(Color(SelectBoxColor().convertUIColor(object: box.boxcolor)).opacity(0.6))
                                    .cornerRadius(15)
                                    .contextMenu {
                                        Button(action: {
                                            self.isdeleted.toggle()
                                            self.compbox = box
                                        }) {
                                            Image("trashbox")
                                            Text("Delete Box")
                                                .font(.title3)
                                        }
                                    }
                                    .shadow(color: .gray, radius: 10, y: 5)
                            }
                            .gesture(TapGesture().onEnded({ _ in
                                modelData.editCompltedBox(object: box)
                            }))
                        
                    }
                }
                .onChange(of: compbox) { newValue in
                    modelData.deleteCompBox(object: compbox!)
                }
            }
            .offset(y:15)
            .frame(height: 600)
            Button(action: {
                self.isdeletebox.toggle()
            }) {
                Image("trashbox")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
            }
            .position(x: 70, y: 60)
            Spacer().alert(isPresented: $isdeletebox) {
                Alert(title: Text("選択されたBoxを削除しますか?"), primaryButton: .default(Text("はい"), action: {
                    modelData.deleteCompBox = deletevector
                    for box in self.deletevector {
                        modelData.compboxs.removeAll { $0.id == box.id }
                    }
                    deletevector.removeAll()
                    idVector.removeAll()
                    modelData.deleteSelectedCompBox()
                    
                }), secondaryButton: .cancel(Text("いいえ")))
            }
        }.background(Color(red: 0.90, green: 0.94, blue: 1.0, opacity: 0.9))
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView()
            .environmentObject(DBViewModel())
    }
}
