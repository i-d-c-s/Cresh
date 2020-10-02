//
//  WorkoutsCell.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/1/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit

class WorkoutsCell: UICollectionViewCell {
    
    @IBOutlet weak var workoutPoster: UIImageView!
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName)
        self.workoutPoster.image = image
    }
    
}
