//
//  GroupChatViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 9/26/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class GroupChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var groupChats = [PFObject]()
    var filteredData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        populateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatCell") as! GroupChatCell
        let gc = self.filteredData[indexPath.row]
        
        let members = gc["members"] as? [String]
        
        cell.ChatNameLabel.text =  gc["groupName"] as? String
        cell.DescriptionLabel.text = gc["caption"] as? String
        cell.MembersLabel.text = String(members!.count) + " Members"
        
        let imageFile = gc["media"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string:urlString)!
        
        cell.PhotoImageView.af_setImage(withURL: url)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text != ""){
            //            let descriptionPredicate =
            //                    NSPredicate(format: "description.contains(%@)",searchText)
            //            let namePredicate =
            //                    NSPredicate(format: "groupName.contains(%@)",searchText)
            //            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [descriptionPredicate, namePredicate])
            //            self.filteredData = self.groupChats.filter { predicate.evaluate(with: $0) };
            
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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
                self.filteredData = self.groupChats
                self.tableView.reloadData()
            }
        }
    }
    
    func postChatDetails(groupName: String, groupCaption: String){
        let imageName = String(format: "defaultChatBackground%d", Int.random(in: 1..<4))
        let image = UIImage(named: imageName)
        if (groupName != ""){
            Post.createGroup(image: image, withName: groupName, withCaption: groupCaption, withCompletion: nil)
        }
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
