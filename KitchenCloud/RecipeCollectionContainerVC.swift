//
//  RecipeCollectionViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/29/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Alamofire

class RecipeCollectionContainerVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var recipes: [Recipe]?
    private let footerId = "footerId"
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    let tapGesture = UIGestureRecognizer(target: self, action: #selector(HomeViewController.hideSearchBar))
    
    var hasQuery = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hasQuery = false
        startIndicator()
        fetchRecipes()
        setupCollectionView()
        print("RecipeCollectionContainer loaded")
    }
    
    var searchPage = Int()
    var defaultPage = Int()
    var query = String()
    func fetchRecipes() {
        let apiKey = "9406b1e81dd739f20845d7c3b48dbe06"
        let endPoint = "http://food2fork.com/api/search"
        let url = URL(string: endPoint)
        var params: Parameters = [String: Any]()
        startIndicator()
        
        // check for query
        if (!self.hasQuery) {
            print("defaultPage: \(self.defaultPage)")
            self.defaultPage += 1
             params = ["key": apiKey, "sort": "t", "page": self.defaultPage]
        } else {
            print("searchPage: \(self.searchPage)")
            self.searchPage += 1
            params = ["key": apiKey, "q": self.query, "page": self.searchPage]
        }

            Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                self.recipes = [Recipe]()
                switch response.result {
                case .success:
                    self.stopIndicator()
                    print("success")
                    if let json = response.result.value as? [String: Any],
                        let dataArray = json["recipes"] as? [[String: Any]] {
                        //print(dataArray)
                        for dictionary in dataArray {
                            let recipe = Recipe()
                            recipe.thumbnailImageName = dictionary["image_url"] as? String
                            recipe.recipeId = dictionary["recipe_id"] as? String
                            recipe.title = dictionary["title"] as? String
                            recipe.publisher = dictionary["publisher"] as? String
                            recipe.socialRank = dictionary["social_rank"] as? Int
                            self.recipes?.append(recipe)
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.collectionView.resetScrollPositionToTop()
                    }
                case .failure:
                    print("failed request")
                }
            }
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let height = (view.frame.width - 16 - 16) * 9 / 16
        layout.itemSize = CGSize(width: view.frame.width, height: height + 16 + 68)
        
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "recipeCell")
        collectionView.register(CollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.backgroundColor = UIColor.white
        collectionView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(collectionView)
    }
    
    func startIndicator()
    {
        //creating view to background while displaying indicator
        let container: UIView = UIView()
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.white
        
        //creating view to display lable and indicator
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 118, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor =  UIColor.lightGray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        //Preparing activity indicator to load
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.frame = CGRect(x: 40, y: 12, width: 40, height: 40)
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingView.addSubview(activityIndicator)
        
        //creating label to display message
        let label = UILabel(frame: CGRect(x: 0, y: 55, width: 120, height: 20))
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.bounds = CGRect(x: 0, y: 0, width: loadingView.frame.size.width / 1.5, height: loadingView.frame.size.height / 2)
        label.font = UIFont(name: "Droind Sans", size: 8.0)
        loadingView.addSubview(label)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        
        self.activityIndicator.startAnimating()
    }
    
    func stopIndicator()
    {
        //disables touch events
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityIndicator.stopAnimating()
        //first
        self.activityIndicator.superview?.superview?.removeFromSuperview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RecipeCollectionContainer will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("RecipeCollectionContainer will disapper")
    }
    
    // MARK: UICollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipe = recipes?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    var recipeId = String()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell at \(indexPath)")
        recipeId = (self.recipes?[indexPath.row].recipeId)!
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CollectionViewFooter
        return footer
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let recipe = self.recipes?[selectedIndexPath.row]
                let dvc = segue.destination as! RecipeDetailViewController
                dvc.rId = recipeId
                dvc.recipe = recipe!
            }
        }
    }
}

extension UIScrollView {
    /// Sets content offset to the top.
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}




