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

class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var groupChats = [PFObject]()
    var filteredData = [PFObject]()
    let notificationViewController = NotificationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        populateTable()
        showNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        populateTable()
        showNavigationBar()
    }
    
    func showNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "Cresh"
        titleLabel.font = UIFont.init(name: "Didot", size: 20)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gc = self.filteredData[indexPath.row]
        let members = gc["members"] as! [String]
  
        let username = (PFUser.current()?.username)!
        if (members.contains(username)){
            self.performSegue(withIdentifier: "memberSegue", sender: gc)
        } else{
            self.performSegue(withIdentifier: "visitorSegue", sender: gc)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text != ""){
            var namesArray = [String]()
            for object in self.filteredData{
                namesArray.append(object["groupName"] as! String)
            }
            self.filteredData.removeAll()
            let namesFilteredArray = namesArray.filter { (item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            print(namesFilteredArray)
            for object in self.groupChats {
                if namesFilteredArray.contains(object["groupName"] as! String){
                    self.filteredData.append(object)
                }
            }
            
        } else{
            self.filteredData = self.groupChats
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
        query.includeKey("author")
        query.findObjectsInBackground { ( objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
    
                self.groupChats = objects
                self.filteredData = self.groupChats
                
                if (self.segmentedController.selectedSegmentIndex == 1){
                    self.selectGC()
                }
                                
                self.tableView.reloadData()
            }
        }
    }
    
    func groupCreationErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Could not create group", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func postChatDetails(groupName: String, groupCaption: String){
        let imageName = String(format: "defaultChatBackground%d", Int.random(in: 1..<4))
        let image = UIImage(named: imageName)
        if (groupName != ""){
            let groupChat = PFObject(className: groupName)
            groupChat.saveInBackground { (success, error) in
                if error != nil{
                    self.groupCreationErrorAlert()
                } else{
                    Post.createGroup(image: image, withName: groupName, withCaption: groupCaption, withCompletion: nil)
                    self.populateTable()
                }
            }
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
    
    @IBAction func dataChoiceChanged(_ sender: Any) {
        populateTable()
    }
    
    @IBAction func addNewGroup(_ sender: Any) {
        createChatDetails()
    }
    
    @IBAction func didTapNotifications(_ sender: Any) {
        self.notificationViewController.filteredData = self.filteredData
        self.present(self.notificationViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "memberSegue"){
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.groupChat = (sender as! PFObject)
        } else{
            let minorGroupDetailViewController = segue.destination as! MinorGroupDetailViewController
            minorGroupDetailViewController.groupDetail = (sender as! PFObject)
        }
        
    }
}
