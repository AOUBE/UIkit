//
//  ViewController.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/4.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items = [ChecklistItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add the following lines
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
    }
    
    // MARK: - Table View Data Source 数据源
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)得到了单元格的副本
        //indexPath 一个指向表中特定行的对象
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell,  with: item)
        configureCheckmark(for: cell,  with: item)
        return cell
    }
    
    // MARK: - Table View Delegate 委托
    //这个方法修改了表格的选择按钮
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        //修改了表格选中状态
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //这个方法是滑动删除的方法
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Actions
    @IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - function
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        //向表格视图单元格询问带有标签1000的视图
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
}
