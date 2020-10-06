//
//  ChatViewController.swift
//  Cresh
//
//  Created by Subomi Popoola on 10/6/20.
//  Copyright © 2020 Subomi Popoola. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {
    var groupChat: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapGroupDetails(_ sender: Any) {
        self.performSegue(withIdentifier: "chatInfoSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }

}
