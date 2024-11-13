//
//  DataModel.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/13.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checkList = Checklist(name: "List")
            lists.append(checkList)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    
    //MARK: - UserDefaults
    func registerDefaults(){
        let dictionary = [
            "ChecklistIndex" : -1,
            "FirstTime" : true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int{
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    //MARK: - Data Saving
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveChecklists(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(
                to:dataFilePath(),
                options:Data.WritingOptions.atomic
            )
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
}