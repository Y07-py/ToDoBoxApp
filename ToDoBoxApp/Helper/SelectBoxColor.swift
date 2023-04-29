//
//  SelectBoxColor.swift
//  ToDoBoxApp
//
//  Created by 木本瑛介 on 2023/04/24.
//

import Foundation
import SwiftUI

struct SelectBoxColor {
    
    let boxcolors:[String]
     = ["blue", "yellow", "orange", "magenta", "teal", "mint", "indigo", "purple", "pink", "gray", "white"
     ]
    
    func convertUIColor(object: String) -> UIColor {
        switch object {
        case "blue":
            return UIColor.blue
        case "yellow":
            return UIColor.yellow
        case "orange":
            return UIColor.orange
        case "magenta":
            return UIColor.magenta
        case "teal":
            return UIColor.systemTeal
        case "mint":
            return UIColor.systemMint
        case "indigo":
            return UIColor.systemIndigo
        case "purple":
            return UIColor.purple
        case "pink":
            return UIColor.systemPink
        case "gray":
            return UIColor.gray
        default:
            return UIColor.white
        }
    }
}
