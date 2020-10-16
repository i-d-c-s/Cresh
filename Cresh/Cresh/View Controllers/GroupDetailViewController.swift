//
//  GroupDetailViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class GroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, myPhotoDelegate, myBtnDelegate {
    
    var groupDetail: PFObject!
    
    @IBOutlet weak var groupImage: PFImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupCaption: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [PFObject?]()
    var timeTrack = 0
    var timer = Timer()
    var activityView: UIActivityIndicatorView!
    var randUser: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self;
        
        populateView()
        loadMembers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PFUser.current()?.setObject(false, forKey: "Looking")
        PFUser.current()?.saveInBackground()
        print("done")
    }
    
    func populateView(){
        let imageData = groupDetail["media"] as? PFFileObject
        self.groupImage.file = imageData
        self.groupName.text = groupDetail["groupName"] as? String
        self.groupCaption.text = groupDetail["caption"] as? String
        self.groupImage.loadInBackground()
    }
    
    func loadMembers(){
        let query = PFUser.query()
        query?.whereKey("username", containedIn: self.groupDetail["members"] as! [String])
        query?.findObjectsInBackground(block: { (objects, error) in
            if error == nil{
                self.users = objects!
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! GroupDetailCell
        cell.delegateBtn = self
        cell.delegatePhoto = self
        cell.user = self.users[indexPath.row] as? PFUser
        cell.setMemberCell(member: self.users[indexPath.row]!)
        return cell
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func photoTapped(cell: GroupDetailCell, didTap: PFUser) {
        self.randUser = didTap
        self.performSegue(withIdentifier: "profileSegue", sender: randUser)
    }
    
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear

        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.center = self.view.center

        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    
    func noRandUserAlert(){
        let alert = UIAlertController(title: "User not Online", message: "Challenge not accepted", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func getRandUser(){
        self.timeTrack += 1
        if (self.randUser.object(forKey: "Looking") != nil) {
                self.timer.invalidate()
                self.activityView.stopAnimating()
                self.performSegue(withIdentifier: "challengeSegue", sender: self.randUser)
            } else{
                if (self.timeTrack == 20) {
                    self.timer.invalidate()
                    self.activityView.stopAnimating()
                    self.timeTrack = 0
                    self.noRandUserAlert()
                    PFUser.current()?.setObject(false, forKey: "Looking")
                    PFUser.current()?.saveInBackground()
                }
            }
        self.randUser.fetchInBackground()
    }
    
    func challengeBtnTapped(cell: GroupDetailCell, didTap: PFUser) {
        self.randUser = didTap
        showActivityIndicatory()
        PFUser.current()?.setObject(true, forKey: "Looking")
        PFUser.current()?.saveInBackground()
        self.timer = Timer.scheduledTimer(timeInterval: 1,
            target: self,
            selector: #selector(getRandUser),
            userInfo: nil,
            repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileSegue"){
            let profileController = segue.destination as! UsersProfileViewController
            profileController.user = sender as? PFUser
        } else if (segue.identifier == "challengeSegue"){
            let challengeController = segue.destination as! GroupChallengeViewController
            challengeController.randomUser = sender as? PFUser
        }
    }
}
