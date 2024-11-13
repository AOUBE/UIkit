//
//  CheckList.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/12.
//
import UIKit

class Checklist: NSObject,Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    
    func countUncheckItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
