//
//  HomeViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/29/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    var user: User?
    var groups = [Groups]()
    var members: [Members] = []
    
    let toPrintString = "I REALLY HOPE THIS WORKS"
    
    var searchButton: UIBarButtonItem = UIBarButtonItem()
    var addButton: UIBarButtonItem = UIBarButtonItem()
    var menuButton: UIBarButtonItem = UIBarButtonItem()

    @IBOutlet var segmentControl: UISegmentedControl!
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmiss(_:)))
    //private var searchBarIsVisible = false
    
    let groupsRef = FIRDatabase.database().reference(withPath: "groups")
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.showsCancelButton = true
        return sb
    }()
    
    private lazy var groupListContainerViewController: GroupListContainerVC = {
        // Load storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var vc = storyboard.instantiateViewController(withIdentifier: "GroupListContainerVC") as! GroupListContainerVC
        self.add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var recipeCollectionViewContoller: RecipeCollectionContainerVC = {
        //load storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var vc = storyboard.instantiateViewController(withIdentifier: "RecipeCollectionContainerVC") as! RecipeCollectionContainerVC
        self.add(asChildViewController: vc)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "List-Icon"), style: .plain, target: self, action: #selector(handleLogout(_:)))
        navigationItem.setLeftBarButton(menuButton, animated: true)
        searchBar.delegate = self
        setupSegmentedController()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        
        view.addSubview(viewController.view)
        //view.addGestureRecognizer(tapGesture)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //viewController.didMove(toParentViewController: self)
    }
    
    func dissmiss(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupSegmentedController() {
        searchButton = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(HomeViewController.searchRecipe(_:)))
        addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(HomeViewController.createGroup(_:)))
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(with: #imageLiteral(resourceName: "Members"), at: 0, animated: false)
        segmentControl.insertSegment(with: #imageLiteral(resourceName: "RecipeBook-logo"), at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            self.navigationItem.rightBarButtonItem = addButton
            remove(asChildViewController: recipeCollectionViewContoller)
            add(asChildViewController: groupListContainerViewController)
        } else {
            self.navigationItem.rightBarButtonItem = searchButton
            remove(asChildViewController: groupListContainerViewController)
            add(asChildViewController: recipeCollectionViewContoller)
        }
    }
        
    @IBAction func handleLogout(_ sender: Any) {
        print("handleLogout called in HomeViewController")
        for vc in (self.navigationController?.viewControllers)! {
            if vc is LoginViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    // MARK: Add button (create group)
    
    var groupID: String?
    func createGroup(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Group Name",
                                      message: "Enter a name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            
            let ref = FIRDatabase.database().reference()
            let groupRef = ref.child("groups").childByAutoId()
            
            //ADD group name to groups(:id) child
            let values = ["name": text]
            groupRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                //success
            }
            
            self.groupID = groupRef.key
            
            let groupMembersRef = groupRef.child("members")
            let groupListRef = groupRef.child("list")
            groupListRef.updateChildValues([:])
            
            //ADD uid to members-child
            groupMembersRef.updateChildValues([uid : 1], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            })
            
            //we also need to add the groupName and group<guid> to users->group
            let userRef = ref.child("users").child(uid)
            let userGroups = userRef.child("groups")
            userGroups.updateChildValues([self.groupID! : 1], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                //success
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func searchRecipe(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        showSearchBar()
        //print("searching recipe")
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        view.alpha = 1
        navigationItem.titleView = searchBar
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBar.alpha = 1
            self.view.alpha = 0.5
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.setLeftBarButton(menuButton, animated: true)
        segmentControl.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.titleView = self.segmentControl
            self.segmentControl.alpha = 1
            self.view.alpha = 1
        }
    }
    
    // MARK: UISearchBar delegate methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let queryString = searchBar.text else { return }
        //fetchApi
        recipeCollectionViewContoller.fetchRecipes(hasQuery: queryString)
        searchBar.resignFirstResponder()
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGroupList" {
            let dvc = segue.destination as? GroupListContainerVC
            dvc?.groups = self.groups
            let backItem = UIBarButtonItem()
            if let font = UIFont(name: "Droid Sans", size: 17) {
                backItem.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
}
