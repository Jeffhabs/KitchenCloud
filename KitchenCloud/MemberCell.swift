//
//  MemberCell.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/12/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    let memberNameLabel: UILabel = {
        let lbl = UILabel()
        //lbl.backgroundColor = UIColor.blue
        lbl.font = UIFont(name: "Droid Sans", size: 15.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let memberEmailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Droid Sans", size: 12.0)
        lbl.alpha = 0.5
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
 
    
    // MARK: Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(memberNameLabel)
        contentView.addSubview(memberEmailLabel)
        
        memberNameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        memberNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        memberNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        //memberNameLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        memberNameLabel.numberOfLines = 0
        
        memberEmailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        memberEmailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        memberEmailLabel.topAnchor.constraint(equalTo: memberNameLabel.bottomAnchor).isActive = true
        memberEmailLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
