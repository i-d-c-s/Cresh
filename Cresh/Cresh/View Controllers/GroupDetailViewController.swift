//
//  GroupDetailViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class GroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupDetail: PFObject!
    
    @IBOutlet weak var groupImage: PFImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupCaption: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [PFObject?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self;
        
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
        cell.setMemberCell(member: self.users[indexPath.row]!)
        return cell
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
