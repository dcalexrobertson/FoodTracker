//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Alex on 2015-11-23.
//  Copyright © 2015 Alex. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    // MARK: Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profilePassword: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let imagePickerController = UIImagePickerController()
    var imageFile:PFFile!
    
    var pickerData: [String] = [String]()

    // MARK: Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        
        pickerView.delegate = self
        pickerData = ["Food Critic", "Casual Foodie"]
    }
    
    // MARK: Actions
    
    @IBAction func profileImagePicker(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        profileImage.resignFirstResponder()
        profilePassword.resignFirstResponder()
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
        
        if let name = profileName.text where !name.isEmpty,
            let password = profilePassword.text where !password.isEmpty,
            let image = imageFile {
        
            let user = PFUser()
            
            user.username = name
            user.password = password
            user.setObject(image, forKey: "profileImage")
            user.setObject(pickerData[pickerView.selectedRowInComponent(0)], forKey: "userType")
            user.signUpInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    print("\(user) sign up successful")
                }
            }
            
            performSegueWithIdentifier("segueToMain", sender: sender)
            
        } else {
            
            print("your stuff is not filled out properly")
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard.
        profileImage.resignFirstResponder()
        profilePassword.resignFirstResponder()
        
        return true
    }

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImage.image = selectedImage
            
            if let data = UIImageJPEGRepresentation(selectedImage, 0.5) {
                
                imageFile = PFFile(data: data)
                imageFile.saveInBackground()
            }
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}
