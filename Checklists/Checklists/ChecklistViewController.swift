//
//  ViewController.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/4.
//

import UIKit




class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()
    var checkList: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = checkList.name
        
        loadChecklistItems()
        
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
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
        saveChecklistItems()
    }
    //这个方法是滑动删除的方法
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    // MARK: - Actions
    
    //MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    
    // MARK: - function
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
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
    
    //MARK: - 数据存储与读取
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        // 1 创建一个PropertyListEncoder实例，该实例将项目数组及其中的所有ChecklistItems编码为某种可以写入文件的二进制数据格式。
        let encoder = PropertyListEncoder()
        // 2
        do {
            // 3 之前创建的编码器用于尝试对项目数组进行编码 try 如果报错 直接跳入catch
            let data = try encoder.encode(items)
            // 4 将编码的文件 写入 dataFilePath返回的路径中
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            // 5 do中包含的代码出错 都会跳转入catch
        } catch {
            // 6
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        // 1
        let path = dataFilePath()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
