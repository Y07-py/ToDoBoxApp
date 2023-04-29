//
//  DBViewModel.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/23.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class DBViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var deadline: Date? = Date()
    @Published var boxcolor: String = "red"
    @Published var updataBox: UncompltedBox?
    @Published var updateBox_2: CompletedBox?
    @Published var isdeleted: Bool = false
    @Published var anauncetime: Date = Date()
    @Published var timeinterval: Double = 0
    @Published var deleteUnCompBoxs: [UncompltedBox] = []
    @Published var isdeadline: Bool = true
    
    @Published var uncompboxs: [UncompltedBox] = []
    @Published var deleteCompBox: [CompletedBox] = []
    
    @Published var compboxs: [CompletedBox] = []
    
    @Published var failedboxs: [FailedBox] = []
    
    private var cancellablePipeline: AnyCancellable?
    
    init() {
        fetchBox()
        fetchCompBox()
        fetchFaildBox()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentDate = Date()
            let cal = Calendar(identifier: .gregorian)
            for box in self.uncompboxs {
                guard let boxdeadline = box.deadline else { return }
                let diff = cal.dateComponents([.second], from: boxdeadline, to: currentDate)
                if diff.second! == 0 {
                    self.uncompboxs.removeAll { $0.id == box.id }
                    self.addFailedBox(object: box)
                    self.deleteBox(object: box)
                }
            }
        }
    }
    
    func addBox() {
        if title == "" { return }
        
        let box = UncompltedBox()
        box.title = title
        box.content = content
        box.boxcolor = boxcolor
        if isdeadline {
            box.deadline = deadline
        }
        else {
            box.deadline = nil
        }
        box.anauncetime = anauncetime
        box.timeinterval = timeinterval
        
        guard let dbRef = try? Realm() else { return }
        
        try? dbRef.write({
            guard let availableObject = updataBox else {
                dbRef.add(box)
                fetchBox()
                return
            }
            availableObject.title = title
            availableObject.content = content
            availableObject.boxcolor = boxcolor
            availableObject.deadline = deadline
            availableObject.anauncetime = anauncetime
            availableObject.timeinterval = timeinterval
        })
        fetchBox()
    }
    
    func fetchBox() {
        guard let dbRef = try? Realm() else { return }
        let results = dbRef.objects(UncompltedBox.self)
        self.uncompboxs = results.compactMap({ (box) in
            return box
        })
    }
    
    func fetchCompBox() {
        guard let dbRef = try? Realm() else { return }
        let results = dbRef.objects(CompletedBox.self)
        self.compboxs = results.compactMap({ (box) in
            return box
        })
    }
    
    func fetchFaildBox() {
        guard let dbRef = try? Realm() else { return }
        let results = dbRef.objects(FailedBox.self)
        self.failedboxs = results.compactMap({ (box) in
            return box
        })
    }
    
    func deleteBox(object: UncompltedBox) {
        guard let dbRef = try? Realm() else { return }
        try? dbRef.write({
            dbRef.delete(object)
            fetchBox()
            fetchCompBox()
        })
    }
    
    func deleteCompBox(object: CompletedBox) {
        guard let dbRef = try? Realm() else { return }
        try? dbRef.write({
            dbRef.delete(object)
            fetchCompBox()
        })
    }
    
    func deleteSelectedUnCompBox() {
        guard let dbRef = try? Realm() else { return }
        for box in deleteUnCompBoxs {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] (timer) in
                try? dbRef.write({
                    dbRef.delete(box)
                    fetchBox()
                })
            }
        }
    }
    
    func deleteSelectedCompBox() {
        guard let dbRef = try? Realm() else { return }
        for box in deleteCompBox {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] timer in
                try? dbRef.write({
                    dbRef.delete(box)
                    fetchCompBox()
                })
            }
        }
    }
    
    func addCompletedBox(object: UncompltedBox) {
        let compbox = CompletedBox()
        compbox.title = object.title
        compbox.content = object.content
        compbox.deadline = object.deadline
        compbox.boxcolor = object.boxcolor
        compbox.anauncetime = anauncetime
        compbox.timeinterval = timeinterval
        
        guard let dbRef = try? Realm() else { return }
        
        try? dbRef.write({
            dbRef.add(compbox)
            fetchCompBox()
        })
        
    }
    
    func addFailedBox(object: UncompltedBox) {
        let failedbox = FailedBox()
        failedbox.title = object.title
        failedbox.content = object.content
        failedbox.deadline = object.deadline
        failedbox.boxcolor = object.boxcolor
        failedbox.anauncetime = object.anauncetime
        failedbox.timeinterval = object.timeinterval
        
        guard let dbRef = try? Realm() else { return }
        
        try? dbRef.write({
            dbRef.add(failedbox)
            fetchFaildBox()
        })
    }
    
    func setupInitialBox() {
        guard let availableBox = self.updataBox else { return }
        title = availableBox.title
        content = availableBox.content
        deadline = availableBox.deadline
        boxcolor = availableBox.boxcolor
        anauncetime = availableBox.anauncetime
        timeinterval = availableBox.timeinterval
    }
    
    func editCompltedBox(object: CompletedBox) {
        title = object.title
        content = object.content
        deadline = object.deadline
        boxcolor = object.boxcolor
        anauncetime = object.anauncetime
        timeinterval = object.timeinterval
    }
    
    func deinitBox() {
        updataBox = nil
        title = ""
        content = ""
        deadline = Date()
    }
}
