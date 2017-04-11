//
//  ItemsListViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/27/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class ItemsListViewController: UITableViewController {
    
    var groupId: String?
    var groupName: String?
    var user: User?
    var items: [ListItem] = []
    var categoryItems = Array([String: AnyObject]())
    
    let toGroupMembers = "toGroupMembers"
    
    let stepper: UIStepper = {
        let st = UIStepper()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.wraps = true
        st.maximumValue = 50
        st.autorepeat = true
        st.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return st
    }()
    
    let alertText: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor.green
        return tf
    }()
    
    let groupNameButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont(name: "Droid Sans", size: 17.0)
        return btn
    }()
    
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font =  UIFont(name: "Droid Sans", size: 17.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupGroupNameButton()
        observeUser()
        observeGroupList()
    }
    
    func setupTableView() {
        self.tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        self.tableView.rowHeight = 65
    }
    
    func setupGroupNameButton() {
        groupNameButton.setTitle(groupName!, for: .normal)
        groupNameButton.addTarget(self, action: #selector(self.groupNameButtonClicked), for: .touchUpInside)
        self.navigationItem.titleView = groupNameButton
    }
    
    func groupNameButtonClicked(button: UIButton) {
        self.performSegue(withIdentifier: self.toGroupMembers, sender: button)
    }
    
    func stepperValueChanged() {
        print("stepper value changed")
    }
    
    // MARK: Firebase observers
    func observeUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userRef = FIRDatabase.database().reference(withPath: "users").child(uid)
        userRef.observe(.value, with: { (snapshot) in
            let userSnap = User()
            if let dictionary = snapshot.value as? [String: Any] {
                userSnap.setValuesForKeys(dictionary)
            }
            self.user = userSnap
        }, withCancel: nil)
    }
    
    func observeGroupList() {
        let ref = FIRDatabase.database().reference(withPath: "lists")
        let groupListRef = ref.child(self.groupId!)
        groupListRef.observe(.value, with: { (snapshot) in
            
            var tmpData = [String: AnyObject]()
            var items = [ListItem]()
            if let dictionary = snapshot.value as? [String: Any] {
                let data = Category()
                for (key, _) in dictionary {
                    data.key = key
                    let item = snapshot.childSnapshot(forPath: data.key!)
                    for elt in item.children {
                        let listItem = ListItem(snapshot: elt as! FIRDataSnapshot)
                        items.append(listItem)
                    }
                    data.items = items
                    items.removeAll()
                    tmpData[data.key!] = data.items as AnyObject
                }
                let myArray = Array(tmpData)
                self.categoryItems = myArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
   
    
    // MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryItems[section].value.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return self.newCatList[section].
        return self.categoryItems[section].key
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        let item = self.categoryItems[indexPath.section].value[indexPath.row] as! ListItem
        cell.itemNameLabel.text = item.name
        cell.addedByLabel.text = "Added by: \(item.addedByUser)"
        cell.qtyLabel.text = item.amount
        cell.unitLabel.text = item.units

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerLabel.text = self.categoryItems[section].key
        headerLabel.textAlignment = NSTextAlignment.center
        return headerLabel
    }
    
    // FIXME: Rename to "toAddItemView"
    @IBAction func addGroceryItem(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddItem", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddItem") {
            let backItem = UIBarButtonItem()
            if let font = UIFont(name: "Droid Sans", size: 17.0) {
                backItem.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
            let dvc = segue.destination as? AddItemViewController
            dvc?.groupId = self.groupId!
            // send the entire user? or just the user name?
            dvc?.user = self.user
        }
    }
}

