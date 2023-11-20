//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mittwoch on 2023/11/5.
//

import UIKit

//itemDetailViewController 的协议 : 与希望使用屏幕AddItem的任意屏幕的协定
protocol ItemDetailViewControllerDelegate: AnyObject{
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController
    )
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem
    )
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item : ChecklistItem
    )
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction func cancel(){
        //        navigationController?.popViewController(animated: true)
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        //        print("Contents of the text field:\(textField.text!)")
        //        navigationController?.popViewController(animated: true)
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK - Table View Delegate 表格委托
    // 表格点击禁用灰色
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // 进入页面的时候直接给textField聚焦
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - 自己写的方法
    // MARK: - Text Field Delegates 委托
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
}
