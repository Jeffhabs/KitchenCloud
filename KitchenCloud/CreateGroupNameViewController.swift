//
//  CreateGroupNameViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/22/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

// FIXME: strip trailing whitespace from textfield
class CreateGroupNameViewController: UIViewController, UITextFieldDelegate {
    
    
    let toCreateUserName = "toCreateUserName"
    
    
    @IBOutlet var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.becomeFirstResponder()
        groupNameTextField.delegate = self
        self.navigationItem.leftBarButtonItem?.title = " "
        if (groupNameTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupNameTextField.resignFirstResponder()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }

    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        groupNameTextField.resignFirstResponder()
        if (groupNameTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userGroupName = groupNameTextField.text else {
            return
        }
        //we need to check if there is a current user
        //if there is, we need to segue to groupListViewController
        //if FIRAuth.user != nil
        if segue.identifier == self.toCreateUserName {
            let dvc = segue.destination as! CreateUserNameViewController
            dvc.groupName = userGroupName
        }
    }
}
