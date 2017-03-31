//
//  CreateUserNameViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/23/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class CreateUserNameViewController: UIViewController, UITextFieldDelegate {
    
    var groupName: String!
    let toEmailAndPassword = "toEmailAndPassword"
    
    @IBOutlet var userNameTextField: UITextField!
    override func viewDidLoad() {
         super.viewDidLoad()
        userNameTextField.delegate = self
        userNameTextField.becomeFirstResponder()
        
        if (userNameTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        //print("Group Name is \(groupName!)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }
    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        userNameTextField.resignFirstResponder()
        if (userNameTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userName = userNameTextField.text else {
            return
        }
        if segue.identifier == self.toEmailAndPassword {
            let dvc = segue.destination as! CreateEmailAndPasswordViewController
            dvc.userName = userName
            dvc.groupName = groupName
        }
    }
    

}
