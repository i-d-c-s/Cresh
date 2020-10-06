//
//  GroupChatCell.swift
//  Cresh
//
//  Created by Alyssa Tan on 10/4/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class GroupChatCell: UITableViewCell {

    @IBOutlet weak var PhotoImageView: PFImageView!
    @IBOutlet weak var ChatNameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var MembersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
