//
//  AddItemViewController.swift
//  KitchenCloud
//
//  Created by Jeffrey Haberle on 4/1/17.
//  Copyright © 2017 Jeff Haberle. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var groupId: String?
    var user: User?
    
    var units: String?
    
    // pickerView
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var categoryLabel: UILabel!
    
    // stepperView
    @IBOutlet var stepperLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    // labels
    @IBOutlet var ozLabel: UILabel!
    @IBOutlet var poundsLabel: UILabel!
    @IBOutlet var pcsLabel: UILabel!
    
    @IBOutlet var itemTextField: UITextField!
    
    let pickerData = ["Meat & Fish", "Dairy", "Fruits", "Vegetables", "Misc", "Tinned Food", "Drinks", "Frozen Food", "Houseware", "Baked Goods", "Candies"]
    
    let saveButton: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Droid Sans", size: 17.0)!], for: .normal)
        btn.title = "Save"
        btn.action = #selector(addGroceryItem)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(4, inComponent: 0, animated: true)
        itemTextField.delegate = self
        setupTapGesture()
        setupNavBar()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Droid Sans", size: 17.0)!]
        self.navigationItem.title = "New Item"
        saveButton.target = self
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    // MARK: Save Button
    // Adds item, upon success it returns them to the ItemsListViewController
    
    func addGroceryItem() {
        guard let itemName = itemTextField.text, let addedBy = self.user?.name, let amount = stepperLabel.text, let unit = self.units, let category = categoryLabel.text else {
            print("error unwrapping an item in addGroceryItem()")
            return
        }
        let listItem = ListItem(name: itemName, addedByUser: addedBy, amount: amount, units: unit, completed: false)
        let listRef = FIRDatabase.database().reference().child("lists").child(self.groupId!).child(category).child(itemName.lowercased())
        let value = listItem.toAnyObject()
        listRef.updateChildValues(value as! [AnyHashable : Any]) { (err, ref) in
            if (err != nil) {
                print("error updating listRef")
                return
            }
            //success
        }
        self.navigationController?.popViewController(animated: true)
        print("saved item")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemTextField.resignFirstResponder()
        guard let itemName = itemTextField.text else {
            print("itemTextField is empty")
            return
        }
        if (!itemName.isEmpty) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        return true
    }
    
    func setupTapGesture() {
        self.pcsLabel.isHighlighted = true
        self.units = self.pcsLabel.text
        self.pcsLabel.isUserInteractionEnabled = true
        self.poundsLabel.isUserInteractionEnabled = true
        self.ozLabel.isUserInteractionEnabled = true
        
        self.pcsLabel.tag = 0
        self.poundsLabel.tag = 1
        self.ozLabel.tag = 2
        
        let tapPcsLbl = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        let tapPoundsLbl = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        let tapOzLbl = UITapGestureRecognizer(target: self, action: #selector(labelTapped))


        self.pcsLabel.addGestureRecognizer(tapPcsLbl)
        self.poundsLabel.addGestureRecognizer(tapPoundsLbl)
        self.ozLabel.addGestureRecognizer(tapOzLbl)

    }
    
    func labelTapped(sender: UITapGestureRecognizer) {
        switch (sender.view?.tag)! {
        case 0:
            self.pcsLabel.highlightedTextColor = UIColor.white
            self.pcsLabel.isHighlighted = true
            self.units = self.pcsLabel.text
            
            self.poundsLabel.isHighlighted = false
            self.ozLabel.isHighlighted = false
            break;
        case 1:
            self.poundsLabel.highlightedTextColor = UIColor.white
            self.poundsLabel.isHighlighted = true
            self.units = self.poundsLabel.text
            
            self.pcsLabel.isHighlighted = false
            self.ozLabel.isHighlighted = false
            break;
        case 2:
            self.ozLabel.highlightedTextColor = UIColor.white
            self.ozLabel.isHighlighted = true
            self.units = self.ozLabel.text
            
            self.pcsLabel.isHighlighted = false
            self.poundsLabel.isHighlighted = false
            break;
        default:
            break;
        }
    }
    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        itemTextField.resignFirstResponder()
    }
    
    // MARK: UIPickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
 
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = self.pickerData[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont(name: "Droid Sans", size: 17.0)!, NSForegroundColorAttributeName:UIColor.white])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryLabel.text = self.pickerData[row]
    }
    
    // MARK: UIStepper method
    @IBAction func stepperTouched(_ sender: UIStepper) {
        stepperLabel.text = Int(sender.value).description
    }    
}
