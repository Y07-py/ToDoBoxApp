//
//  ContentView.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataModel: DBViewModel
    
    @State private var selectedTab: Int = 0
    @State private var canSwipe: Bool = false
    
    let list: [String] = ["list", "completed", "failed"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Divider()
                    TopTabView(list: list, selectedTab: $selectedTab)
                    TabView(selection: $selectedTab) {
                        HomeView()
                            .tag(0)
                        CompletedView().tag(1)
                        FailedView().tag(2)
                    }
                    .tabViewStyle(.page)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DBViewModel())
    }
}
