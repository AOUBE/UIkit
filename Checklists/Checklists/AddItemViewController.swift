//
//  AddItemViewController.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/8.
//

import UIKit

class AddItemViewController: UITableViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    //MARK: - Table View Delegates
    //禁止此行被选中
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Text Field Delegates
    // textField(_:shouldChangeCharactersIn:replacementString:) 不会提供新文本，只为你提供文本的那一部分需要替换
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText =  textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // 这个是用来判断是否为空的
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    //textfield 清除的时候会调用的方法
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    //MARK: - Actions
    @IBAction func cancel(){
        //        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        //        print("Contents of the text field: \(textField.text!)")
        //        
        //        navigationController?.popViewController(animated: true)
        
        let item = ChecklistItem()
        item.text = textField.text!
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    //MARK: - function
    //textField 聚焦
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
}
