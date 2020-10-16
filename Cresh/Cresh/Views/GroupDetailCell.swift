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

    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var delegatePhoto: myPhotoDelegate?
    var delegateBtn: myBtnDelegate?
    
    var user: PFUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let photoTap = UITapGestureRecognizer.init(target: self, action: #selector(tapPhoto(sender:)))
        self.profilePicture.addGestureRecognizer(photoTap)
        self.profilePicture.isUserInteractionEnabled = true
        
        let btnTap = UITapGestureRecognizer.init(target: self, action: #selector(tapBtn(sender:)))
        self.challengeButton.addGestureRecognizer(btnTap)
        self.challengeButton.isUserInteractionEnabled = true
        
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
        let imageData = member.object(forKey: "image") as? PFFileObject
        self.profilePicture.file = imageData
        self.profilePicture.loadInBackground()
    }

    @objc func tapPhoto(sender: UITapGestureRecognizer) {
        delegatePhoto?.photoTapped(cell: self, didTap: user!)
       }
    
    @objc func tapBtn(sender: UITapGestureRecognizer) {
        delegateBtn?.challengeBtnTapped(cell: self, didTap: user!)
       }
    
}

protocol myPhotoDelegate {
    func photoTapped(cell: GroupDetailCell, didTap: PFUser)
}

protocol myBtnDelegate {
    func challengeBtnTapped(cell: GroupDetailCell, didTap: PFUser)
}
