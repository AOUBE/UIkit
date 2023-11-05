//
//  ViewController.swift
//  Checklists
//
//  Created by Mittwoch on 2023/11/5.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table View Data Source 表格数据源
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    // cellForRowAt 外部名称。indexPath：内部名称
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let lable = cell.viewWithTag(1000) as! UILabel
        
        if indexPath.row % 5 == 0 {
            lable.text = "Walk the dog"
        } else if indexPath.row % 5 == 1 {
            lable.text = "Brush my teeth"
        } else if indexPath.row % 5 == 2 {
            lable.text = "Learn IOS development"
        } else if indexPath.row % 5 == 3 {
            lable.text = "Soccer practice"
        } else if indexPath.row % 5 == 4 {
            lable.text = "Eat ice cream"
        }
        
        return cell
    }
    
    // MARK - Table View Delegate 表格委托
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

