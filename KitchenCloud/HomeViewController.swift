//
//  HomeViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 3/29/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var user: User?
    var groups = [Groups]()
    var members: [Members] = []
    
    @IBOutlet var groupListContainer: UIView!
    @IBOutlet var recipesViewContainer: UIView!
    
    @IBOutlet var segmentControl: UISegmentedControl!
    
    let currUser = FIRAuth.auth()?.currentUser?.uid
    let userRef = FIRDatabase.database().reference(withPath: "users")
    let groupsRef = FIRDatabase.database().reference(withPath: "groups")
    
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
        print("homeviewcontroller")
        setupView()
        updateView()
        observeUserGroups() { results in
            //self.groups.a
            self.groups = results
            for group in self.groups {

            }
        }
        
        //print(self.groups)
    }
    
    private func setupView() {
        setupSegmentedController()
    }
    
    func observeUserGroups(completion: @escaping ([Groups]) -> Void) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("groups")
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            let groupid = snapshot.key
            let groupReference = FIRDatabase.database().reference().child("groups").child(groupid)
            
            groupReference.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                var groupArray = [Groups]()
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let groups = Groups()
                    groups.setValuesForKeys(dictionary)
                    //print(groups.name!)
                    //print(groups.members!)
                    //self.groups.append(groups)
                    groupArray.append(groups)
                    //self.groups.append(groups)
                }
                completion(groupArray)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //viewController.didMove(toParentViewController: self)
        
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
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(with: #imageLiteral(resourceName: "Members"), at: 0, animated: false)
        segmentControl.insertSegment(with: #imageLiteral(resourceName: "RecipeBook-logo"), at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            //set right nav add button
            remove(asChildViewController: recipeCollectionViewContoller)
            add(asChildViewController: groupListContainerViewController)
        } else {
            //self.navigationItem.rightBarButtonItem = nil
            remove(asChildViewController: groupListContainerViewController)
            add(asChildViewController: recipeCollectionViewContoller)
        }
    }
    
    // MARK: Add button (create group)
    var groupID: String?
    @IBAction func createGroup(_ sender: Any) {
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
            
            //let groupListRef = groupRef.child("list")
            let groupMembersRef = groupRef.child("members")
            
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

}
