//
//  LoginViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/24/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var toHomeView = "loginToHome"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextDelegates()
        
        //Open keyboard on entry
        emailTextField.becomeFirstResponder()
        
        //Disable 'Next' button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupTextDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
    }
    
    // MARK: UITextFieldDelegate methods
    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        guard let password = passwordTextField.text else { return }
        
        switch (textField.tag) {
        case 1:
            emailTextField.resignFirstResponder()
            break
        case 2:
            passwordTextField.resignFirstResponder()
            if !(password.isEmpty) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            break
        default:
            break;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch (textField.tag) {
        case 1:
            //nothing
            break
        case 2:
            //nothing
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField.tag) {
        case 1:
            emailTextField.resignFirstResponder()
            break
        case 2:
            passwordTextField.resignFirstResponder()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            break
        default:
            break;
        }
        return true
    }
 
    // MARK: Next button logs user in
    
    var pendingItems: [PendingInvites] = []
    //var user: User?
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let ref = FIRDatabase.database().reference()

        guard let email = emailTextField.text, let password = passwordTextField.text else {
            //handle error
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            if err != nil {
                //alert
                return
            }
            //success
            let currUserId = FIRAuth.auth()?.currentUser?.uid
            let pendingRef = FIRDatabase.database().reference(withPath: "pending-invites")
            
            
            pendingRef.observe(.value, with: { (snapshot) in
                let dict = snapshot.value as? [String: Any] ?? [:]
                print(dict)
                var newItems: [PendingInvites] = []
                
                for item in snapshot.children {
                    let pendingItem = PendingInvites(snapshot: item as! FIRDataSnapshot)
                    newItems.append(pendingItem)
                    print(item)
                    
                }
                
                // FIXME: Check if child("groups") exist is a child called "groups" in our User collection
                // see firebase documentation
                
                let userGroupRef = ref.child("users").child(currUserId!).child("groups")
                
                self.pendingItems = newItems
                for i in self.pendingItems {
                    if i.targetEmail == email {
                        
                        //add group<> to currentUser.groups
                        let test = userGroupRef.child(i.group)
                        ref.child("groups").child(i.group).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? [String: Any] ?? [:]
                            let groupName = value["name"] as? String ?? ""
                            test.setValue(["name": groupName])
                        })
                        
                        // FIXME: This needs to be updated and fixed with Fanout pattern
                        //we also need to update members in our groups collection
                        //add user<> and user email to members
                        print("Current User Id: \(currUserId!)")
                        let newMember = ["email": i.targetEmail]
                        let newGroupMember = ref.child("groups").child(i.group).child("members").child(currUserId!)
                        newGroupMember.updateChildValues(newMember, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print("error updating new group member \(err!)")
                                return
                            }
                            //success
                        })
                        //finally we need to delete the pending-invite from the collection so we can iterate faster
                        pendingRef.child(i.key).removeValue()
                    }
                }
                
                self.performSegue(withIdentifier: self.toHomeView, sender: nil)
                
            })
        })
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let backItem = UIBarButtonItem()
//        if let font = UIFont(name: "Droid Sans", size: 17) {
//            backItem.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
//            backItem.title = "Logout!"
//            navigationItem.leftBarButtonItem = backItem
//        }
//    }
//    func handleLogout() {
//        print("handleLogout called in loginViewController")
//        do {
//            try FIRAuth.auth()?.signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//        let loginController = LoginViewController()
//        present(loginController, animated: true, completion: nil)
//    }

}
