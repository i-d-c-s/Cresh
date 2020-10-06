//
//  SignUpViewController.swift
//  Cresh
//
//  Created by Alyssa Tan on 9/27/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
    
    func errorAlert() {
        let alert = UIAlertController(title: "An Error Occured", message: "There was an error signing up, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dupUsernameAlert() {
        let alert = UIAlertController(title: "Username ", message: "Please choose a new username and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if (usernameTextField.text == "" || passwordTextField.text == "" || emailTextField.text == ""){
            self.emptyFieldAlert()
        }
        else{
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.email = emailTextField.text
            //can add step here to check if username is already taken
            let query = PFUser.query()!
            query.whereKey("username", equalTo:user.username!)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    if(objects.count != 0){
                        self.dupUsernameAlert()
                    }else{
                        user.signUpInBackground {
                            (succeeded: Bool, error: Error?) -> Void in
                            if let error = error {
                                let errorString = error.localizedDescription
                                print("Error: \(String(describing: errorString))")
                                self.errorAlert()
                            } else {
                                self.performSegue(withIdentifier: "signUpSuccessSegue", sender: nil);
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
