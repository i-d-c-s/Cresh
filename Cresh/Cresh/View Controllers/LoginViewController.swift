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
    
    var username = String()
    var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username = usernameField.text!
        self.password = passwordField.text!

    }
    
    func emptyFieldAlert(){
        let alert = UIAlertController(title: "Details Required", message: "Fill in empty fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func wrongUserAlert(){
        let alert = UIAlertController(title: "Invalid Details", message: "We Could not find this User", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if (self.username.isEmpty || self.password.isEmpty){
            self.emptyFieldAlert()
        }
        else{
            PFUser.logInWithUsername(inBackground: self.username, password: self.password) { (user, error) in
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
