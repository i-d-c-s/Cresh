//
//  WorkOutsGridViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/1/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class WorkOutsGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var workOuts: [String] = []
    var randUser: PFUser!
    var timeTrack = 0
    var timer = Timer()
    var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        editCollectionViewLayout()
        
        self.workOuts = ["pushUps", "inclinePushUps", "declinePushUps", "squats", "pullUps", "sprints"]
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PFUser.current()?.setObject(false, forKey: "Looking")
        PFUser.current()?.saveInBackground()
        print("done")
    }
    
    func editCollectionViewLayout(){
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
                
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2.5) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.125)
    }
    
    func notImplementedAlert(){
        let alert = UIAlertController(title: "Coming soon", message: "Feature on the rise", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workOuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutsCell", for: indexPath) as! WorkoutsCell
        cell.setImage(imageName: self.workOuts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.workOuts[indexPath.row] == "squats") {
            self.performSegue(withIdentifier: "squatSegue", sender: nil)
        } else if (self.workOuts[indexPath.row] == "pushUps") {
            self.performSegue(withIdentifier: "pushUpSegue", sender: nil)
        } else{
            self.notImplementedAlert()
        }
    }
    
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear

        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.center = self.view.center

        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    
    func noRandUserAlert(){
        let alert = UIAlertController(title: "Couldn't find User", message: "No user found", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func getRandUser(){
        let query = PFUser.query()!
        query.whereKey("username", notEqualTo: PFUser.current()?.username!)
        query.whereKey("Looking", equalTo: true)
        query.findObjectsInBackground { (objects, error) in
            if (error == nil){
                self.timeTrack += 1
                if (!objects!.isEmpty){
                    self.randUser = (objects![0] as! PFUser)
                    self.timer.invalidate()
                    self.activityView.stopAnimating()
                    self.performSegue(withIdentifier: "randChallengeSegue", sender: nil)
                } else{
                    if (self.timeTrack == 20){
                        self.timer.invalidate()
                        self.activityView.stopAnimating()
                        self.timeTrack = 0
                        self.noRandUserAlert()
                        PFUser.current()?.setObject(false, forKey: "Looking")
                        PFUser.current()?.saveInBackground()
                    }
                }
            }
        }
    }
    
    @IBAction func challengeButtonTapped(_ sender: Any) {
        showActivityIndicatory()
        PFUser.current()?.setObject(true, forKey: "Looking")
        PFUser.current()?.saveInBackground()
        self.timer = Timer.scheduledTimer(timeInterval: 1,
            target: self,
            selector: #selector(getRandUser),
            userInfo: nil,
            repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "randChallengeSegue"){
            let randChallengeController = segue.destination as! RandChallengeViewController
            randChallengeController.randomUser = randUser
        }
    }

}
