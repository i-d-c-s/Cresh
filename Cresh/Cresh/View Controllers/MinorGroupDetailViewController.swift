//
//  MinorGroupDetailViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/7/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class MinorGroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupDetail: PFObject!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupCaption: UILabel!
    @IBOutlet weak var groupImage: PFImageView!
    
    var users = [PFObject?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        populateView()
        loadMembers()
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
    
    func requestSentAlert(){
        let alert = UIAlertController(title: "Request Sent", message: "Your request to join as been sent", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! GroupDetailCell
        cell.setMemberCell(member: self.users[indexPath.row]!)
        return cell
    }
    
    @IBAction func didTapJoinButton(_ sender: Any) {
        let notification = ["name": PFUser.current()!.username!, "group": groupDetail["groupName"] as! String]
        var notifications = self.groupDetail["notifications"] as? [[String:String]]
        if (notifications == nil){
            notifications = [[String:String]]()
        }
        notifications?.append(notification)
        self.groupDetail["notifications"] = notifications
        self.groupDetail.saveInBackground()
        requestSentAlert()
    }
    
}
