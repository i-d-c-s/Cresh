//
//  MinorDetailsCell.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/16/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class MinorDetailsCell: UITableViewCell {

    @IBOutlet weak var profilePic: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
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
        self.profilePic.layer.borderWidth = 1.0
        self.profilePic.layer.masksToBounds = false
        self.profilePic.layer.borderColor = UIColor.gray.cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.clipsToBounds = true
    }

}
