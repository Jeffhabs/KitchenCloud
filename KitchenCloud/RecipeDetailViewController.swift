//
//  RecipeDetailViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/19/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Alamofire


class RecipeDetailViewController: UIViewController {
    
    var rId = String()
    
    var recipe = Recipe()
    
    @IBOutlet var publisherUrlButton: UIButton!
    @IBOutlet var detailThumbNail: CustomImageView!
    @IBOutlet var ingredientsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("recipe id : \(rId)")
        setupThumbnailImage()
        self.publisherUrlButton.setTitle("View on the \(self.recipe.publisher!)", for: .normal)
        self.publisherUrlButton.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        fetchRecipe(rId: rId)
    }
    
    func setupThumbnailImage() {
        detailThumbNail.contentMode = .scaleAspectFill
        detailThumbNail.clipsToBounds = true
        if let thumbnailImageUrl = recipe.thumbnailImageName {
            //print(thumbnailImageView)
            detailThumbNail.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    func showWebView() {
        self.performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let dvc = segue.destination as? WebViewContoller
            dvc?.sourceUrl = self.recipe.sourceUrl!
        }
    }
    
    func fetchRecipe(rId: String) {
        let apiKey = "9406b1e81dd739f20845d7c3b48dbe06"
        let endPoint = "http://food2fork.com/api/get"
        let url = URL(string: endPoint)
        var params: Parameters = [String: Any]()
        params = ["key": apiKey, "rId": rId]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            self.recipe = Recipe()
            switch response.result {
            case .success:
                print("success")
                if let json = response.result.value as? [String: Any],
                    let dataArray = json["recipe"] as? [String: Any] {
//                        print(json)
//                        print("*******************")
//                        print(dataArray)
                        self.recipe.title = dataArray["title"] as? String
                        self.recipe.ingredients = dataArray["ingredients"] as? [String]
                    self.recipe.sourceUrl = dataArray["source_url"] as? String
                }
                self.navigationItem.title = self.recipe.title
                var toString = String()
                for item in self.recipe.ingredients! {
                    toString += ("• " + item + "\n")
                }
                self.ingredientsLabel.text = toString
            case .failure:
                print("failed request")
            }
        }
    }
}
