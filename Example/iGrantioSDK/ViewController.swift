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
        iGrantioSDK.shared.modalPresentationStyle = .fullScreen
        iGrantioSDK.shared.show(organisationId: "603e683c69dd720001c74f93", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2MDNlNjdkYjY5ZGQ3MjAwMDFjNzRmOTAiLCJleHAiOjE2NDU4ODI0NjN9.9GxRitStk3eaggQL-lCAfY1z2cRMZlq3TPqwdTq0aSQ", userId: "605cb3508f373f00016b65f9")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

