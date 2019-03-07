//
//  ViewController.swift
//  iGrantFramework
//
//  Created by rebinkpmna@gmail.com on 02/18/2019.
//  Copyright (c) 2019 rebinkpmna@gmail.com. All rights reserved.
//

import UIKit
import iGrantFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showIgrantView(_ sender: Any) {
        iGrantViewController.shared.show(organisationToken: "5c1507365430460001af621a", userToken: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

