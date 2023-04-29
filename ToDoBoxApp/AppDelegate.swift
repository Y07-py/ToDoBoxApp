//
//  AppDelegate.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/29.
//

import Foundation
import SwiftUI
import RealmSwift

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notification: NotificationHandler = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notification.askPermission()
        let config = Realm.Configuration(schemaVersion: 7)
        Realm.Configuration.defaultConfiguration = config
        
        return true
        
    }
}
