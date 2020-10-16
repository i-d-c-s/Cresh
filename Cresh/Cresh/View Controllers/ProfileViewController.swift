//
//  ProfileViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse
import Charts

class ProfileViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var numChallengesLabel: UILabel!
    @IBOutlet weak var numWinsLabel: UILabel!
    @IBOutlet weak var numLossesLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var numPushupLabel: UILabel!
    @IBOutlet weak var numInclinePushupLabel: UILabel!
    @IBOutlet weak var numDeclinePushupLabel: UILabel!
    @IBOutlet weak var numSquatsLabel: UILabel!
    
    var lineChartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        populateView()
        constructingChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        populateView()
        constructingChart()
    }
    
    func constructingChart() {
        self.lineChartView.delegate = self
        self.lineChartView.backgroundColor = UIColor.init(red: 2566.0, green: 256.0, blue: 256.0, alpha: 1)
        self.lineChartView.chartDescription!.enabled = false
        self.lineChartView.pinchZoomEnabled = false
        self.lineChartView.dragEnabled = false
        self.lineChartView.setScaleEnabled(true)
        self.lineChartView.legend.enabled = false
        self.lineChartView.xAxis.enabled = false
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.legend.textColor = .black
        self.view.addSubview(self.lineChartView)
    }
    
    func populateChart(){
        
        self.numPushupLabel.alpha = 0
        self.numInclinePushupLabel.alpha = 0
        self.numDeclinePushupLabel.alpha = 0
        self.numSquatsLabel.alpha = 0
        
        self.lineChartView.alpha = 1
        self.lineChartView.frame = CGRect(x: 20, y: self.view.frame.size.height / 2, width: self.view.frame.size.width - 40, height: (self.view.frame.size.height - self.view.frame.size.height / 1.5) - 10)
        let squatData = PFUser.current()?.object(forKey: "SquatTrack") as! [Int]
        var modelData = [String]()
        for index in stride(from: squatData.count, to: 0, by: -1){
            modelData.append(String(format: "%0d", index))
        }

        if squatData.count > 0{
            self.lineChartView.data = setChart(dataPoints: modelData, values: squatData)
        } else{
            self.lineChartView.data = nil
        }
    }
    
    func setChart(dataPoints: [String], values: [Int]) -> LineChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Record")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.colors = colors
        return lineChartData
    }

    func populateView() {
        
        self.numPushupLabel.alpha = 1
        self.numInclinePushupLabel.alpha = 1
        self.numDeclinePushupLabel.alpha = 1
        self.numSquatsLabel.alpha = 1
        self.lineChartView.alpha = 0
        
        let user = PFUser.current()!
        let imageData = user.object(forKey: "image")
        self.profileImage.layer.cornerRadius = 72
        self.profileImage.layer.masksToBounds = true
        if (imageData != nil){
            self.profileImage.file = (imageData as! PFFileObject)
            self.profileImage.loadInBackground()
        }
        let username = user.username
        self.usernameLabel.text = "@\(username!)"
        var lost = user.object(forKey: "Lost") as? Int
        if lost  == nil {
            lost = 0
        }
        self.numLossesLabel.text = String(format: "Lost: %0d", lost!)
        var wins = user.object(forKey: "Won") as? Int
        if wins == nil {
            wins = 0
        }
        self.numWinsLabel.text = String(format: "Won: %0d", wins!)
        self.numChallengesLabel.text = String(format: "Challenges: %0d", wins! + lost!)
        let school = user.object(forKey: "School") as? String
        if school == nil{
            self.schoolLabel.alpha = 0
        } else {
            self.schoolLabel.text = school
        }
        let gender = user.object(forKey: "Gender") as? String
        if gender == nil {
            self.genderLabel.alpha = 0
        } else {
            self.genderLabel.text = gender
        }
        let squats = user.object(forKey: "squats") as? Int
        if squats == nil {
            self.numSquatsLabel.text = "Squats: 0"
        } else {
            self.numSquatsLabel.text = String(format: "Squats: %0d", squats!)
        }
        let pushUps = user.object(forKey: "pushUps") as? Int
        if pushUps == nil {
            self.numPushupLabel.text = "PushUps: 0"
        } else {
            self.numPushupLabel.text = String(format: "PushUps: %0d", pushUps!)
        }
        let inclinePushUps = user.object(forKey: "inclinePushUps") as? Int
        if inclinePushUps == nil {
            self.numInclinePushupLabel.text = "Incline PushUps: 0"
        } else {
            self.numInclinePushupLabel.text = String(format: "Incline PushUps: %0d", inclinePushUps!)
        }
        let declinePushUps = user.object(forKey: "declinePushUps") as? Int
        if declinePushUps == nil {
            self.numDeclinePushupLabel.text = "Decline PushUps: 0"
        } else {
            self.numDeclinePushupLabel.text = String(format: "Decline PushUps: %0d", declinePushUps!)
        }
    }
    
    @IBAction func dataFormatChanged(_ sender: Any) {
        if (self.segmentedController.selectedSegmentIndex == 0){
            populateView()
        } else{
            populateChart()
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "settingSegue", sender: nil)
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if let error = error{
                print(error.localizedDescription)
            } else{
                print("Successful logout")
                let main = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = main.instantiateViewController(identifier: "loginViewController")
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = loginViewController
            }
        }
    }

}
