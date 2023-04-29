//
//  FailedBox.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/29.
//

import Foundation
import SwiftUI
import RealmSwift

class FailedBox: Object, Identifiable {
    @objc dynamic var id: UUID = UUID()
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var boxcolor: String = "white"
    @objc dynamic var deadline: Date?
    @objc dynamic var isdeleted: Bool = false
    @objc dynamic var anauncetime: Date = Date()
    @objc dynamic var timeinterval: Double = 0
}