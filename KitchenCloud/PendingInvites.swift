//
//  PendingInvites.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/24/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import Firebase

struct PendingInvites {
    
    let key: String
    let targetEmail: String
    let sender: String
    let group: String
    let ref: FIRDatabaseReference?
    
    init(sender: String, targetEmail: String, group: String, key: String = " ") {
        self.key = key
        self.targetEmail = targetEmail
        self.sender = sender
        self.group = group
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        sender = snapshotValue["sender"] as! String
        targetEmail = snapshotValue["targetEmail"] as! String
        group = snapshotValue["group"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "sender": sender,
            "targetEmail": targetEmail,
            "group": group
        ]
        
    }
    
}
