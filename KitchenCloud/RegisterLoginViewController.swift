//
//  ViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/22/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {
    
    let toCreateGroupName = "toCreateGroup"
    let toLogin = "toLogin"

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8
        registerButton.layer.masksToBounds = true

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

