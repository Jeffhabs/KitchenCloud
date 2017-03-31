//
//  Members.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/28/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class Members {
    
    //Members key is the same as the the uid
    var key: String?
    var email: String
    var userName: String
    var ref: FIRDatabaseReference?
    
    /*
    // Default init
    init(key: String = " ", email: String, userName: String) {
        self.key = key
        self.email = email
        self.userName = userName
        self.ref = nil
    }
    */
    
    // Snapshot init
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        email = snapshotValue["email"] as! String
        userName = snapshotValue["username"] as! String
        ref = snapshot.ref
    }
}
