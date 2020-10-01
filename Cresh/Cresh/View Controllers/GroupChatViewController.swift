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

    @IBAction func addNewGroup(_ sender: Any) {
    }
   
}
