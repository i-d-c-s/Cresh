//
//  UsersProfileViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/14/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class UsersProfileViewController: UIViewController {
    
    var user: PFUser!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numLossesLabel: UILabel!
    @IBOutlet weak var numWinsLabel: UILabel!
    @IBOutlet weak var numChallengesLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var numSquatsLabel: UILabel!
    @IBOutlet weak var numPushupLabel: UILabel!
    @IBOutlet weak var numInclinePushupLabel: UILabel!
    @IBOutlet weak var numDeclinePushupLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateView()
    }
    
    func populateView() {
        let imageData = user.object(forKey: "image") as? PFFileObject
        self.profileImage.layer.cornerRadius = 72
        self.profileImage.layer.masksToBounds = true
        if (imageData != nil){
            self.profileImage.file = imageData
            self.profileImage.loadInBackground()
        }
        let username = user.username
        self.usernameLabel.text = "@\(username!)"
        var lost = user.object(forKey: "Lost") as? Int
        if lost  == nil {
            lost = 0
        }
        self.numLossesLabel.text = String(format: "Lost: %0d", lost!)
        var wins = user.object(forKey: "Won") as? Int
        if wins == nil {
            wins = 0
        }
        self.numWinsLabel.text = String(format: "Won: %0d", wins!)
        self.numChallengesLabel.text = String(format: "Challenges: %0d", wins! + lost!)
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
            self.numSquatsLabel.text = String(format: "Squats: %0d", squats!)
        }
        let pushUps = user.object(forKey: "pushUps") as? Int
        if pushUps == nil {
            self.numPushupLabel.text = "PushUps: 0"
        } else {
            self.numPushupLabel.text = String(format: "PushUps: %0d", pushUps!)
        }
        let inclinePushUps = user.object(forKey: "inclinePushUps") as? Int
        if inclinePushUps == nil {
            self.numInclinePushupLabel.text = "Incline PushUps: 0"
        } else {
            self.numInclinePushupLabel.text = String(format: "Incline PushUps: %0d", inclinePushUps!)
        }
        let declinePushUps = user.object(forKey: "declinePushUps") as? Int
        if declinePushUps == nil {
            self.numDeclinePushupLabel.text = "Decline PushUps: 0"
        } else {
            self.numDeclinePushupLabel.text = String(format: "Decline PushUps: %0d", declinePushUps!)
        }
    }

   
    @IBAction func dataChanged(_ sender: Any) {
    }
    
}
