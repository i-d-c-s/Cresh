//
//  NotificationViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/7/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notifications: [[String:String]]!
    var filteredData: [PFObject]!
    var groupDetail: PFObject!
    let notificationTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNotifications()
        constructNotificationViewController()
        
        self.notificationTable.delegate = self
        self.notificationTable.dataSource = self
    
    }
    
    func getNotifications(){
        self.notifications = [[String:String]]()
        for element in self.filteredData{
            let owner = element["author"] as! PFUser
            if (owner.username == PFUser.current()?.username!){
                var dummy = element.object(forKey: "notifications") as? [[String:String]]
                if (dummy == nil){
                    dummy = [[String:String]]()
                } else{
                    self.notifications.append(contentsOf: dummy!)
                }
            }
        }
        print(self.notifications.count)
        print(self.filteredData.count)
        notificationTable.reloadData()
    }
    
    func constructNotificationViewController(){
        self.view.backgroundColor = .lightGray
        self.view.addSubview(notificationTable)
        
        notificationTable.translatesAutoresizingMaskIntoConstraints = false
        notificationTable.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        notificationTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        notificationTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        notificationTable.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        notificationTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    }
    
    func getObject(groupName: String) {
        for data in self.filteredData{
            if (data["groupName"] as! String == groupName){
                self.groupDetail = data
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let notification = self.notifications[indexPath.row]
        cell.textLabel?.text = notification["name"]! + " requested to join " + notification["group"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = self.notifications[indexPath.row]
        let groupName = notification["group"]!
        
        getObject(groupName: groupName)
        
        var members = self.groupDetail.object(forKey: "members") as! [String]
        if (!members.contains(notification["name"]!)){
            members.append(notification["name"]!)
        }
       
        self.groupDetail["members"] = members
        self.groupDetail.saveInBackground()
    }
}
