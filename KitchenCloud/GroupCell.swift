//
//  GroupCell.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/29/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    let groupNameLabel: UILabel = {
        let lbl = UILabel()
        //lbl.backgroundColor = UIColor.blue
        lbl.font = UIFont(name: "Droid Sans", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let membersLabel = UILabel()
    
    // MARK: Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(groupNameLabel)
        groupNameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        groupNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        groupNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        groupNameLabel.numberOfLines = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
