//
//  ItemsListViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/27/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class ItemsListViewController: UITableViewController {
    
    var groupId: String?
    var groupName: String?
    
    let toGroupMembers = "toGroupMembers"
    
    let groupNameButton: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("ItemsListView: \(groupId)")
        self.navigationItem.backBarButtonItem?.isEnabled = true
        
        setupGroupNameButton()
    }
    
    func setupGroupNameButton() {
        groupNameButton.setTitle(groupName!, for: .normal)
        groupNameButton.addTarget(self, action: #selector(self.groupNameButtonClicked), for: .touchUpInside)
        self.navigationItem.titleView = groupNameButton
    }
    
    func groupNameButtonClicked(button: UIButton) {
        self.performSegue(withIdentifier: self.toGroupMembers, sender: button)
    }

}
