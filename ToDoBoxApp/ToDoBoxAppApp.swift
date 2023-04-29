//
//  ToDoBoxAppApp.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/23.
//

import SwiftUI

@main
struct ToDoBoxAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var dataModel: DBViewModel = DBViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
        }
    }
}
