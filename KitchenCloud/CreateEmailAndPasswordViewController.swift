//
//  CreateEmailAndPasswordViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/23/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class CreateEmailAndPasswordViewController: UIViewController, UITextFieldDelegate {

    var userName: String!
    var groupName: String!
    
    
    let toHomeView = "toHome"
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var reEnterPasswordTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        setupTextFieldDelegates()
        
        if (reEnterPasswordTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        print("User Name is \(userName!)")
        print("Group name is \(groupName!)")
    }

    func setupTextFieldDelegates() {
        emailTextField.delegate = self
        reEnterPasswordTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        reEnterPasswordTextField.tag = 3
    }

    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let password = passwordTextField.text, let reEnterPassword = reEnterPasswordTextField.text else { return }
        
        //switch case statement
        switch (textField.tag) {
        case 1:
            emailTextField.resignFirstResponder()
            break;
        case 2:
            passwordTextField.resignFirstResponder()
            break;
        case 3:
            reEnterPasswordTextField.resignFirstResponder()
            if !(password.isEmpty) && reEnterPassword == password {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            break;
        default:
            break;
        }
    }
    
    // FIXME: Test if clearing makes Next button disable/enable
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //guard let password = passwordTextField.text, let reEnterPassword = reEnterPasswordTextField.text else { return true }
        
        //switch case statement
        switch (textField.tag) {
        case 1:
            emailTextField.resignFirstResponder()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            break;
        case 2:
            passwordTextField.resignFirstResponder()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            break;
        case 3:
            reEnterPasswordTextField.resignFirstResponder()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            break;
        default:
            break;
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //switch case statement
        switch (textField.tag) {
        case 1:
            break;
        case 2:
            break;
        case 3:
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            break;
        default:
            break;
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let password = passwordTextField.text, let reEnterPassword = reEnterPasswordTextField.text else { return true }
        
        //switch case statement
        switch (textField.tag) {
        case 1:
            emailTextField.resignFirstResponder()
            break;
        case 2:
            passwordTextField.resignFirstResponder()
            break;
        case 3:
            reEnterPasswordTextField.resignFirstResponder()
            if !(password.isEmpty) && reEnterPassword == password {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            break;
        default:
            break;
        }
        return true;
    }
    
    // MARK: DissmissKeyboard on tap view
    @IBAction func dissmissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        reEnterPasswordTextField.resignFirstResponder()
    }
    
    // MARK: Create user, create group, log user in
    //this is the last next button for my registration process
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // TODO: Alert user if form is invalid
            print("error invalid form")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                // TODO: Alert user if error occurs
                print("error creating user %s", error!)
            }
            
            // successfully authenticated user
            guard let uid = user?.uid else { return }
            let ref = FIRDatabase.database().reference()
            let userRef = ref.child("users").child(uid)
            let values = ["name": self.userName!, "email": email]
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    // TODO: Alert
                    print("register error %s", err!)
                    return
                }
            })
            
            let createrUid = FIRAuth.auth()?.currentUser?.uid
            let groupRef = ref.child("groups").childByAutoId()
            
            //ADD group name to groups(:id) child
            let groupVal = ["name": self.groupName!]
            groupRef.updateChildValues(groupVal) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                //success
            }
            
            let groupID = groupRef.key
            
            let groupMembersRef = groupRef.child("members")
            groupMembersRef.updateChildValues([createrUid! : 1], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            })
            
            //we also need to add the groupName and group<guid> to users->group
            let userGroups = userRef.child("groups")

            userGroups.updateChildValues([groupID : 1], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                //success
            })
            self.performSegue(withIdentifier: self.toHomeView, sender: nil)
        })
    }
}
