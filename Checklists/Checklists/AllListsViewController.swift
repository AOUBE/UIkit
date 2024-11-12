//
//  AllListsViewController.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/11.
//

import UIKit

class AllListsViewController: UITableViewController {
    let cellIdentifier = "ChecklistCell"
    
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //使用表视图注册了我们的单元格标识符
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath)
        
        let checkList = lists[indexPath.row]
        cell.textLabel!.text = checkList.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ChecklistViewController到ItemDetailViewController点击一行将自动执行segue，因为您已将segue连接到原型单元格。
        //AllListsViewController到ChecklistViewController，此屏幕的表格视图没有使用原型单元格，必须手动执行segue。
        let checkList = lists[indexPath.row]
        //还要通过prepare(for:sender:)  获取 sender
        performSegue(withIdentifier: "ShowChecklist", sender: checkList)
    }
    
    //MARK: - Navigation
    //prepare(for:sender:)是在视图控制器发生segue之前调用的。在这里，您有机会在新视图控制器可见之前设置其属性
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checkList = sender as? Checklist
        }
    }
}
