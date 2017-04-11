//
//  SectionData.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/9/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import Foundation
import Firebase

struct SectionData {
    
    // the name or key
    var key: String?
    var values: [ListItem]?
    
    init(key: String, values: [ListItem]) {
        self.key = key
        self.values = values
    }
    
    init() {
        self.key = nil
        self.values = nil
    }
    
    func updateValues(values: [ListItem], forKey: String) -> SectionData {
        let result = SectionData(key: forKey, values: values)
        return result
    }
    
//    func updateValues(newArray: [ListItem], forKey: String) -> SectionData {
//        var encountered = Set<String>()
//        var result = SectionData(key: forKey, values: newArray)
//        //let result = SectionData(key: forKey, values: newArray)
//        //resultArray.append(result)
//        return result
//    }
}

//func removeDuplicates(array: [String]) -> [String] {
//    var encountered = Set<String>()
//    var result: [String] = []
//    for item in array {
//        if encountered.contains(item) {
//            // Do not add a duplicate element
//        } else {
//            // Add value to the set.
//            encountered.insert(item)
//            result.append(item)
//        }
//    }
//    return result
//}

