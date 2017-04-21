//
//  CollectionViewFooter.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/20/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class CollectionViewFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let nextButton: UIButton = {
        let btn = UIButton()
        let font = UIFont(name: "Droid Sans", size: 17.0)
        let appBlue = UIColor(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
        btn.setTitle("Next Page", for: .normal)
        btn.titleLabel?.font = font
        btn.setTitleColor(appBlue, for: .normal)
        btn.addTarget(self, action: #selector(RecipeCollectionContainerVC.fetchRecipes), for: .touchDown)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func setupViews() {
        addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
