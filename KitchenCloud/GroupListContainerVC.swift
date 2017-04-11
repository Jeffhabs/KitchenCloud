//
//  GroupListViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/23/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

// TODO: Handle Logout from leftTabBarButton

class GroupListContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let toItemListView = "toItemListView"
    var groups = [Groups]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = 65
        tv.register(GroupCell.self, forCellReuseIdentifier: "groupCell")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observeUserGroups()
        print("GroupListContainerView loaded")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("GroupListContainerView will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("GroupListContainerView will disapper")
        
    }

    private func setupTableView() {
        //need x, y, height, width
        self.view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    var groupIds = [String]()
    
    // MARK: Firebase Observer methods
    // FIXME: add .childRemoved??
    func observeUserGroups() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("groups")
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            let groupid = snapshot.key
            self.groupIds.append(groupid)
            
            let groupReference = FIRDatabase.database().reference().child("groups").child(groupid)
            groupReference.observe(.value, with: { (snapshot) in
                //print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let groups = Groups()
                    groups.setValuesForKeys(dictionary)
                    self.groups.append(groups)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    // MARK: UITableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    var memberKeys = [String]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.groupNameLabel.text = self.groups[indexPath.row].name
        memberKeys = Array(self.groups[indexPath.row].members!.keys)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toItemList", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "toItemList" {
                let dvc = segue.destination as! ItemsListViewController
                dvc.groupId = self.groupIds[indexPath.row]
                dvc.groupName = self.groups[indexPath.row].name
            }
        }
    }
    
    func observeGroupMembers() {
        for items in self.groups {
            self.memberKeys = Array(items.members!.keys)
        }
        print(self.memberKeys)
    }

    
    // MARK: UITableView Delegate methods
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let groupItem = groups[indexPath.row]
        
        //get groupId to display group members in cell
        let groupId = groupItem.key
        let groupIdRef = groupRef.child(groupId).child("members")
        groupIdRef.observe(.value, with: { (snapshot) in
            var memberList = [Members]()
            for item in snapshot.children {
                let memberItem = Members(snapshot: item as! FIRDataSnapshot)
                
                memberList.append(memberItem)
            }
            
            self.members = memberList
            var memberStr = " "
            
            for item in self.members {
                if self.members.count > 1 {
                    // FIXME: this comma may be in the wrong spot
                    memberStr += item.userName + ", "
                } else {
                    memberStr += item.userName                }
            }
            cell.membersLabel.text = memberStr
            
        })
        cell.groupNameLabel.text = groupItem.name
        return cell
    }
    */
    
    // MARK: ADD BUTTON create a new group via UIAlert
    /*
     
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = " "
        navigationItem.backBarButtonItem = backButton
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let dvc = segue.destination as! ItemsListViewController
            dvc.groupId = self.groups[indexPath.row].key
            dvc.groupName = self.groups[indexPath.row].name
        }
    }
    */
    */

}


