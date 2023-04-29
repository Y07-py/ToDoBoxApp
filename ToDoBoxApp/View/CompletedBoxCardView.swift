//
//  CompletedBoxCardView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import SwiftUI

struct CompletedBoxCardView: View {
    
    @ObservedObject var box: CompletedBox
    
    @State private var selectedid: UUID?
    @State var iscircle: Bool = false
    @State var isdelete: Bool = false
    @State var showingAlert: Bool = false
    
    @Binding var deletevector: [CompletedBox]
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
                            self.deletevector.removeAll {
                                $0.id == box.id
                            }
                            self.idVector.removeAll {
                                $0 == box.id
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(self.iscircle ? Color.green : Color.white)
                        }
                    }
                    .offset(x: 10)
                    Text(box.title)
                        .frame(width: 300, height: 80)
                        .lineLimit(2)
                        .font(.title2)
                        .foregroundColor(.primary)
                    Image("checkedbox_2")
                    .offset(x: -10)
            }
        }
    }
}

