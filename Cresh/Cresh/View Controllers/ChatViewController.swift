//
//  ChatViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var groupChat: PFObject!
    var chatMessages = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 150
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableTapped(tapGestureRecognizer:)))
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        self.title = groupChat["groupName"] as? String
            
        populateTable()
    }
    
    @objc func tableTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let c = self.chatMessages[indexPath.row]
        cell.messageLabel.text = c["message"] as? String
        cell.usernameLabel.text = c["sender"] as? String
        return cell
    }
    
    @IBAction func didTapGroupDetails(_ sender: Any) {
        self.performSegue(withIdentifier: "chatInfoSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let groupDetailViewConroller = navigationController.topViewController as! GroupDetailViewController
        groupDetailViewConroller.groupDetail = groupChat
    }

    @IBAction func sendPressed(_ sender: Any) {
        if self.messageTextField.text != ""{
            let user = PFUser.current()!
            let chat = PFObject(className:"Chats")
            chat["sender"] = user.username
            chat["message"] = self.messageTextField.text
            chat["groupChat"] = groupChat!.value(forKey: "objectId")!
            chat.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    self.messageTextField.text = ""
                    self.view.endEditing(true)
                    self.populateTable()
                } else {
                    // There was a problem, check error.description
                }
            }
        }
    }
    
    func populateTable() {
        let query = PFQuery(className:"Chats")
        query.order(byDescending: "createdAt")
        query.whereKey("groupChat", equalTo: groupChat!.value(forKey: "objectId")!)
        query.includeKey("author")
        query.findObjectsInBackground { ( objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                self.chatMessages = objects
                self.tableView.reloadData()
            }
        }
    }
}
