//
//  FailedView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import SwiftUI

struct FailedView: View {
    
    @EnvironmentObject var dateModel: DBViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(dateModel.failedboxs) { box in
                        NavigationLink(destination: DetailFailedBoxView(box: box)) {
                            FailedBoxCardView(box: box)
                                .background(Color(SelectBoxColor().convertUIColor(object: box.boxcolor)).opacity(0.6))
                                .cornerRadius(15)
                                .shadow(color: .gray, radius: 15, x: 5, y: 5)
                        }
                    }
                }
            }
            .frame(height: 600)
            .offset(y: -40)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 0.90, green: 0.94, blue: 1.0))
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView()
            .environmentObject(DBViewModel())
    }
}
