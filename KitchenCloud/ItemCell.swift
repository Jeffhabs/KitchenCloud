//
//  ItemCell.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/1/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
       
    let itemNameLabel: UILabel = {
        let lbl = UILabel()
        //lbl.backgroundColor = UIColor.blue
        lbl.font = UIFont(name: "Droid Sans", size: 15.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let addedByLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Droid Sans", size: 12.0)
        lbl.alpha = 0.5
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let qtyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Droid Sans", size: 15.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let unitLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Droid Sans", size: 15.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(addedByLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(unitLabel)
        
        itemNameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        //itemNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        itemNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        itemNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        itemNameLabel.numberOfLines = 0
        
        //need x, y, width, height
        addedByLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor).isActive = true
        addedByLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor).isActive = true
        addedByLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8).isActive = true
        addedByLabel.numberOfLines = 0
        
        //need x, y, width, height
        qtyLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        //qtyLabel.centerXAnchor.constraint(equalTo: itemNameLabel.centerXAnchor, constant: 50).isActive = true
        qtyLabel.bottomAnchor.constraint(equalTo: addedByLabel.topAnchor).isActive = true
        qtyLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -35).isActive = true
        
        //need x, y, width, height
        unitLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        unitLabel.leadingAnchor.constraint(equalTo: qtyLabel.trailingAnchor).isActive = true
        unitLabel.bottomAnchor.constraint(equalTo: qtyLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
