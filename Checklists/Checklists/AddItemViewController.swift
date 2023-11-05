//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Mittwoch on 2023/11/5.
//

import UIKit

class AddItemViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(){
        navigationController?.popViewController(animated: true)
    }
}
