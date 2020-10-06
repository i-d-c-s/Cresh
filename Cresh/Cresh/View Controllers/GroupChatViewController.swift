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
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        populateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        populateTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatCell") as! GroupChatCell
        let gc = self.filteredData[indexPath.row]
        
        let members = gc["members"] as? [String]
        let imageFile = gc["media"] as! PFFileObject
        
        cell.ChatNameLabel.text =  gc["groupName"] as? String
        cell.DescriptionLabel.text = gc["caption"] as? String
        cell.MembersLabel.text = String(members!.count) + " Members"
        cell.PhotoImageView.layer.cornerRadius = 18
        cell.PhotoImageView.layer.masksToBounds = true
        cell.PhotoImageView.file = imageFile
        cell.PhotoImageView.loadInBackground()
        
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
    
    func selectGC(){
        var dummy_data = [PFObject]()
        for element in self.filteredData{
            let data = element["members"] as! [String]
            if data.contains((PFUser.current()?.username)!){
                dummy_data.append(element)
            }
        }
        self.filteredData = dummy_data
        self.groupChats = self.filteredData
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
                
                if (self.segmentedController.selectedSegmentIndex == 1){
                    self.selectGC()
                }
                                
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
        populateTable()
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
    
    @IBAction func dataChoiceChanged(_ sender: Any) {
        populateTable()
    }
    
    @IBAction func addNewGroup(_ sender: Any) {
        createChatDetails()
    }
    
}
