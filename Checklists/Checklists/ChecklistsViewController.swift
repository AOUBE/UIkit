//
//  ViewController.swift
//  Checklists
//
//  Created by Mittwoch on 2024/4/21.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let item1 = ChecklistItem()
        item1.text = "walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "brush my teeth"
        item2.checked = true
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "learn ios development"
        item3.checked = true
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "soccer pratice"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "eat ice cream"
        item5.checked = true
        items.append(item5)
        
    }
    
    
    //MARK: - Table View Data Source 数据源协议
    //这个方法签签名为：tableView(_:numberOfRowsInSection)  numberOfRowsInSection外部名称 selection内部名称  如果不想要外部名称，使用_替代。 （->）这个后面的是返回值
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegate
    //用户点击单元格的时候会调用此方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - function
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}
