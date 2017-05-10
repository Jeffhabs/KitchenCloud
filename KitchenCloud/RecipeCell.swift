//
//  RecipeCell.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/18/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    var recipe: Recipe? {
        didSet {
            titleLabel.text = recipe?.title
            publisherLabel.text = recipe?.publisher
            let rating = "\(recipe?.socialRank ?? 0)"
            
            ratingLabel.text = rating
            setupThumbnailImage()
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = recipe?.thumbnailImageName {
            //print(thumbnailImageView)
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 25
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
        label.font = UIFont(name: "Droid Sans", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Droid Sans", size: 17.0)
        //label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Droid Sans", size: 15.0)
        label.alpha = 0.5
        //label.backgroundColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
     func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(publisherLabel)
        addSubview(ratingLabel)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|-16-[v0]-68-|", views: thumbnailImageView)

        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        //titleLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        publisherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        //publisherLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor).isActive = true
        publisherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        publisherLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8).isActive = true
        publisherLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        ratingLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ratingLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 16).isActive = true
        separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
