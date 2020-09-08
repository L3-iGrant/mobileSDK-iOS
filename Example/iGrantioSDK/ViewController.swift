//
//  ViewController.swift
//  iGrantFramework
//
//  Created by rebinkpmna@gmail.com on 02/18/2019.
//  Copyright (c) 2019 rebinkpmna@gmail.com. All rights reserved.
//

import UIKit
import iGrantioSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showIgrantView(_ sender: Any) {
        iGrantViewController.shared.modalPresentationStyle = .fullScreen
        iGrantViewController.shared.show(organisationToken: "5c1507365430460001af621a", userToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI1ZjUzMWY3MmM2NzAwMTAwMDEwMGY5ZWYiLCJleHAiOjE2MzA1MDcwNTJ9.ZcIuXYN0WhIvid0jV4Y-SiPSGKWR8WwpfX3HmuwbRKg")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

