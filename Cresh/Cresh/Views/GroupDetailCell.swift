//
//  GroupDetailCell.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class GroupDetailCell: UITableViewCell {

    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMemberCell(member: PFObject){
        self.usernameLabel.text = member["username"] as? String
        self.rankLabel.text = member["rank"] as? String
        self.profilePicture.layer.borderWidth = 1.0
        self.profilePicture.layer.masksToBounds = false
        self.profilePicture.layer.borderColor = UIColor.gray.cgColor
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.clipsToBounds = true
    }
    
    @IBAction func didTapChallenge(_ sender: Any) {
    }
}
