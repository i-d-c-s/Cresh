//
//  GroupChatViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 9/26/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class GroupChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var groupChats = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func populateTable() {
        let query = PFQuery(className:"Post")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { ( objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfully retrieved \(objects.count) objects")
                self.groupChats = objects
            }
        }
    }
    
    func postChatDetails(groupName: String, groupCaption: String){
       
    }
    
    func createChatDetails() {
        let alert = UIAlertController(title: "Create Group", message: "enter chat info", preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter Group Name"
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter Group Description"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (UIAlertAction) in
            let groupName = alert.textFields![0].text ?? ""
            let groupCaption = alert.textFields![1].text ?? ""
            self.postChatDetails(groupName: groupName, groupCaption: groupCaption)
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func addNewGroup(_ sender: Any) {
        createChatDetails()
    }
   
}
