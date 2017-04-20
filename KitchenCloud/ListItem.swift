//
//  ListItem.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/31/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import Foundation
import Firebase

/**
 
 List
  --<groupid>
  ----<category>
  ------<item_name_lowercased>
  -------- addedByUser: "Jeff"
  -------- amount: "1"
  -------- completed: "false"
  -------- name: "Tuna Fish"
  -------- units: "pcs"
 
 **/

class ListItem {
    
    let key: String
    let name: String
    let addedByUser: String
    let amount: String
    let units: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    
    init(name: String, addedByUser: String, amount: String, units: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.amount = amount
        self.units = units
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        amount = snapshotValue["amount"] as! String
        units = snapshotValue["units"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "amount": amount,
            "units": units,
            "completed": completed
        ]
    }
}

// Category is a key value data structure
// @properties: key: String of category Name, items: list of ListItem objects
class Category {
    
    //key is category name
    var key: String?
    var items: [ListItem]?
}









