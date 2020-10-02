//
//  WorkOutsGridViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/1/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit

class WorkOutsGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var workOuts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.workOuts = ["pushUps", "inclinePushUps", "declinePushUps", "squats", "pullUps", "sprints"]
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workOuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutsCell", for: indexPath) as! WorkoutsCell
        cell.setImage(imageName: self.workOuts[indexPath.row])
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
