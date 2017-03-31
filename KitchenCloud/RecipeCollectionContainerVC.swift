//
//  RecipeCollectionViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/29/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class RecipeCollectionContainerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RecipeCollectionContainer loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RecipeCollectionContainer will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("RecipeCollectionContainer will disapper")
    }
}
