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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecipes(hasQuery: nil)
        
        setupCollectionView()
        print("RecipeCollectionContainer loaded")
    }
    
    func fetchRecipes(hasQuery: String?) {
        let apiKey = "9406b1e81dd739f20845d7c3b48dbe06"
        let endPoint = "http://food2fork.com/api/search"
        let url = URL(string: endPoint)
        var params: Parameters = [String: Any]()
        
        // check for query
        if (hasQuery == nil) {
             params = ["key": apiKey, "sort": "t"]
        } else {
            guard let searchQuery = hasQuery else { return }
            params = ["key": apiKey, "q": searchQuery]
        }

            Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                
                self.recipes = [Recipe]()
                switch response.result {
                case .success:
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
                case .failure:
                    print("failed request")
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RecipeCollectionContainer will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("RecipeCollectionContainer will disapper")
    }
    
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
    
    var recipeId = String()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell at \(indexPath)")
        recipeId = (self.recipes?[indexPath.row].recipeId)!
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
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



