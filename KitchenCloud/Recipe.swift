//
//  Recipe.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/17/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    
    var recipeId: String?
    var thumbnailImageName: String?
    var sourceUrl: String?
    var title: String?
    var publisher: String?
    var publisherUrl: String?
    var socialRank: Int?
    var ingredients: [String]?
}
