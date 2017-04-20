//
//  GroupMembersViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/11/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class GroupMembersViewController: UITableViewController {
    
    var groupId = String()
    let ref = FIRDatabase.database().reference()
    let groupRef = FIRDatabase.database().reference(withPath: "groups")
    
    var members = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Droid Sans", size: 17.0)!]
        self.navigationItem.title = "Members"
        observeGroupMembers()
        setupTableView()
    }
    
    // MARK: Firebase observer methods
    var user = [User]()
    
    func observeGroupMembers() {
        // path:/groups/group{id}/members returns collection of members by groupId
        let groupMembersRef = groupRef.child(self.groupId).child("members")
        groupMembersRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            let usersRef = FIRDatabase.database().reference(withPath: "users")
            let memberId = snapshot.key
            let memberRef = usersRef.child(memberId)
            memberRef.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    self.members.append(dictionary)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func setupTableView() {
        self.tableView.register(MemberCell.self, forCellReuseIdentifier: "MemberCell")
        self.tableView.rowHeight = 45
    }
    
    // MARK: UITableView delegate methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        let member = self.members[indexPath.row]
        let name = member["name"] as! String
        let email = member["email"] as! String
        
        cell.memberNameLabel.text = name
        cell.memberEmailLabel.text = email
        return cell
    }
 
    //add button to add a new member to the group using pending-invites collection
    @IBAction func addNewMember(_ sender: Any) {
        let alert = UIAlertController(title: "Invite",
                                      message: "Add a new member to group",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Send", style: .default) { action in
            
            guard let emailField = alert.textFields?.first, let text = emailField.text else { return }
            guard let senderId = FIRAuth.auth()?.currentUser?.uid else {
                print("no user id")
                return
            }
            
            let ref = FIRDatabase.database().reference(withPath: "pending-invites").childByAutoId()
            //let pendingRef = ref.child("pending-invites").childByAutoId()
            let pendingItem = PendingInvites(sender: senderId, targetEmail: text, group: self.groupId)
            
            ref.setValue(pendingItem.toAnyObject())
            //let values = ["sender": senderId, "targetEmail": emailField, "group": self.groupId] as [String : AnyObject]
            
            
            //ref.setValue(values)
//            ref.updateChildValues(values) { (err, ref) in
//                if err != nil {
//                    print("error inviting user %s", err!)
//                    return
//                }
//                //success
//            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter email"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
}
