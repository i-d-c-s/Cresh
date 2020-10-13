//
//  ProfileViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var numChallengesLabel: UILabel!
    @IBOutlet weak var numWinsLabel: UILabel!
    @IBOutlet weak var numLossesLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var numPushupLabel: UILabel!
    @IBOutlet weak var numInclinePushupLabel: UILabel!
    @IBOutlet weak var numDeclinePushupLabel: UILabel!
    @IBOutlet weak var numSquatsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        populateView()
    }
    
    func populateView() {
        let user = PFUser.current()!
        let imageData = user.object(forKey: "image")
        self.profileImage.layer.cornerRadius = 72
        self.profileImage.layer.masksToBounds = true
        if (imageData != nil){
            self.profileImage.file = (imageData as! PFFileObject)
            self.profileImage.loadInBackground()
        }
        self.usernameLabel.text = String(format: "@%s", user.username!)
        var lost = user.object(forKey: "Lost") as? Int
        if lost  == nil {
            lost = 0
        }
        self.numLossesLabel.text = String(format: "Lost: %d", lost!)
        var wins = user.object(forKey: "Lost") as? Int
        if wins == nil {
            wins = 0
        }
        self.numWinsLabel.text = String(format: "Won: %d", wins!)
        self.numChallengesLabel.text = String(format: "Challenges: %d", wins! + lost!)
        let school = user.object(forKey: "School") as? String
        if school == nil{
            self.schoolLabel.alpha = 0
        } else {
            self.schoolLabel.text = school
        }
        let gender = user.object(forKey: "Gender") as? String
        if gender == nil {
            self.genderLabel.alpha = 0
        } else {
            self.genderLabel.text = gender
        }
        let squats = user.object(forKey: "squats") as? Int
        if squats == nil {
            self.numSquatsLabel.text = "Squats: 0"
        } else {
            self.numSquatsLabel.text = String(format: "Squats: %d", squats!)
        }
        let pushUps = user.object(forKey: "pushUps") as? Int
        if pushUps == nil {
            self.numPushupLabel.text = "PushUps: 0"
        } else {
            self.numSquatsLabel.text = String(format: "PushUps: %d", pushUps!)
        }
        let inclinePushUps = user.object(forKey: "inclinePushUps") as? Int
        if inclinePushUps == nil {
            self.numInclinePushupLabel.text = "Incline PushUps: 0"
        } else {
            self.numInclinePushupLabel.text = String(format: "Incline PushUps: %d", inclinePushUps!)
        }
        let declinePushUps = user.object(forKey: "declinePushUps") as? Int
        if declinePushUps == nil {
            self.numDeclinePushupLabel.text = "Decline PushUps: 0"
        } else {
            self.numDeclinePushupLabel.text = String(format: "Decline PushUps: %d", declinePushUps!)
        }
    }
    
    @IBAction func dataFormatChanged(_ sender: Any) {
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                print("Successful logout")
                let main = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = main.instantiateViewController(identifier: "loginViewController")
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = loginViewController
            }
        }
    }

}
