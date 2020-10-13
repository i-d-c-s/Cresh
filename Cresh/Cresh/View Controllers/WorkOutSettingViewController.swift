//
//  WorkOutSettingViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/13/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit

class WorkOutSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let defaults = UserDefaults.standard
    var possibleHeights = [[Int]]()
    
    var heightValue: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildHeights()
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    
    func buildHeights() {
        for i in 4...8{
            for j in 0...12{
                self.possibleHeights.append([i, j])
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.possibleHeights.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let height = self.possibleHeights[row]
        return String(format: "%d '%d", height[0], height[1])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let height = self.possibleHeights[row]
        self.heightLabel.text = String(format: "Height: %d '%d", height[0], height[1])
        
        let inches = Double(height[1])
        let feet = Double(height[0])
        
        let decimalHeight = inches / 12.0
        self.heightValue = feet + decimalHeight
    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        self.timeLabel.text = String(format: "Time: %dmins", self.slider.value)
    }
    
    @IBAction func timeSwitchedMoved(_ sender: Any) {
        if (self.timeSwitch.isOn){
            self.slider.alpha = 0;
            self.timeLabel.text = "Time: ??mins"
        } else{
            self.slider.alpha = 1;
            self.timeLabel.text = String(format: "Time: %dmins", self.slider.value)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.defaults.set(self.heightValue, forKey: "Height")
        
        if (self.timeSwitch.isOn){
            self.defaults.set(0, forKey: "Time")
        } else{
            self.defaults.set(Int(self.slider.value), forKey: "Time")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
