//
//  User.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/23/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import Foundation
import Firebase

class User {
    let userName: String
    let email: String
    let groups: [String: Any]
    let ref: FIRDatabaseReference?
    
    init(email: String, userName: String, groups: [String: Any]) {
        self.email = email
        self.userName = userName
        self.groups = groups
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        groups = snapshotValue["groups"] as! [String: Any]
        email = snapshotValue["email"] as! String
        userName = snapshotValue["name"] as! String
        ref = snapshot.ref
        
    }
}



/*
class Groups {
    let key: String
    let name: String
    let members: [String: Any]
    let ref: FIRDatabaseReference?
    
    init(key: String = " ", name: String, members: [String: Any]) {
        self.key = key
        self.name = name
        self.members = members
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        members = snapshotValue["members"] as! [String: Any]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
*/





