//
//  KeyboardHandler.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/29.
//

import Foundation
import SwiftUI
import Combine

class KeyboardHandler: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0.0
    
    func startHandler() {
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func stopHandler() {
        NotificationCenter
            .default
            .removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let keyboardBeginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let endMinY = keyboardEndFrame.cgRectValue.minY
            let beginMinY = keyboardBeginFrame.cgRectValue.minY
            keyboardHeight = beginMinY - endMinY
            if keyboardHeight < 0 {
                keyboardHeight = 0
            }
        }
    }
    
}
