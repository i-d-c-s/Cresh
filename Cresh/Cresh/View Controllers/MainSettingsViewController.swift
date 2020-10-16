//
//  MainSettingsViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/14/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class MainSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = 86.5
        self.profileImage.layer.masksToBounds = true
        
        addTapGestureRecognizer()
        
        editImagePosition()
        editSchoolField()
        editGenderField()
    }
    
    func editImagePosition(){
        let y = (self.view.frame.size.height / 2) - 170
        let x = (self.view.frame.size.width - 170) / 2
        self.profileImage.frame = CGRect(x: x, y: y, width: 173, height: 173)
    }
    
    func editSchoolField(){
        self.schoolTextField.frame.size.width = self.view.frame.size.width - 40
        self.schoolTextField.frame.origin.x = 20
        self.schoolTextField.frame.origin.y = (self.view.frame.size.height / 2) + 100
    }
    
    func editGenderField(){
        self.genderTextField.frame.size.width = self.view.frame.size.width - 40
        self.genderTextField.frame.origin.x = 20
        self.genderTextField.frame.origin.y = (self.view.frame.size.height / 2) + 200
    }
    
    func errorAlert(){
        let alert = UIAlertController.init(title: "Invalid Details", message: "Something went wrong", preferredStyle: .alert)
        let okAlert = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAlert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func emptyFieldAlert(){
        let alert = UIAlertController.init(title: "Empty Field", message: "Fill in empty fields", preferredStyle: .alert)
        let okAlert = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAlert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func pictureSource(){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        
        let alert = UIAlertController.init(title: "Camera", message: "Choose source", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction.init(title: "Camera", style: .default) { (UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerVC.sourceType = .camera
            }else{
                print("Camera 🚫 available so we will use photo library instead")
                imagePickerVC.sourceType = .photoLibrary
            }
            self.present(imagePickerVC, animated: true, completion: nil)
        }
        
        let librarySource = UIAlertAction.init(title: "Photo Library", style: .default) { (action) in
            imagePickerVC.sourceType = .photoLibrary
            self.present(imagePickerVC, animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        alert.addAction(librarySource)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTapGestureRecognizer(){
        let camGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapImage(sender:)))
        self.profileImage.addGestureRecognizer(camGesture)
        self.profileImage.isUserInteractionEnabled = true
    }
    
    @objc func didTapImage(sender: UITapGestureRecognizer) {
        pictureSource()
       }
    
    func resizeImage(image: UIImage, size: CGSize) -> UIImage {
        let resizeImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        resizeImageView.contentMode = .scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage]
        self.profileImage.image = self.resizeImage(image: editedImage as! UIImage, size: CGSize(width: 414, height: 414))
        self.profileImage.layer.cornerRadius = 98
        self.profileImage.layer.masksToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if (schoolTextField.text == "" || genderTextField.text == ""){
            emptyFieldAlert()
        } else{
            let user = PFUser.current()!
            user.setObject(schoolTextField.text!, forKey: "School")
            user.setObject(genderTextField.text!, forKey: "Gender")
            let imageData = Post.getPFFileFromImage(image: self.profileImage.image)
            user.setObject(imageData!, forKey: "image")
            user.saveInBackground { (success, error) in
                if (error != nil){
                    self.errorAlert()
                } else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
