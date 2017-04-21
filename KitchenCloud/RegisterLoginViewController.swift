//
//  ViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/22/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class RegisterLoginViewController: UIViewController {
    
    let toCreateGroupName = "toCreateGroup"
    let toLogin = "toLogin"
    let loggedIn = "loggedIn"

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        registerButton.layer.cornerRadius = 8
        registerButton.layer.masksToBounds = true
    }
    
    func checkIfUserIsLoggedIn() {
        guard  let uid = FIRAuth.auth()?.currentUser?.uid else {
            print("No user currently logged in")
            return
        }
        print("current user uid: \(uid)")
        perform(#selector(handleLoggedIn), with: nil, afterDelay: 0)
    }
    
    func handleLoggedIn() {
        self.performSegue(withIdentifier: self.loggedIn, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
 
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: self.toCreateGroupName, sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: self.toLogin, sender: nil)
    }
}

