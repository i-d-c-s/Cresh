//
//  LoginViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 9/24/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func emptyFieldAlert() {
        let alert = UIAlertController(title: "Details Required", message: "Fill in empty fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func wrongUserAlert() {
        let alert = UIAlertController(title: "Invalid Details", message: "We Could not find this User", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if (usernameField.text == "" || passwordField.text == ""){
            self.emptyFieldAlert()
        }
        else{
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user, error) in
                if (user != nil){
                    self.performSegue(withIdentifier: "loginSegue", sender: nil);
                } else{
                    self.wrongUserAlert()
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    @IBAction func registerUser(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: nil);
    }
    
    @IBAction func toggleKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
