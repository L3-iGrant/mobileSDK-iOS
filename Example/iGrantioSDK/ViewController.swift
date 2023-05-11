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
//        iGrantioSDK.shared.createIGrantUser(orgId: "5e899ded7e7cba00018166e4",apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI1ZTg5OGFmMTdlN2NiYTAwMDE4MTY2ZTMiLCJleHAiOjE2NDkyMjgzNTF9.60vbvPiqzcPYQY7VmIGx57niBWC_af9VjR-HEQs3a1s") {(success, userId) in
//            print("USErID \(userId)")
//        }
        
        iGrantioSDK.shared.modalPresentationStyle = .fullScreen
        iGrantioSDK.shared.show(organisationId: "638dd3b12f5d1700014431ec", apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiI2MzhkZTMzMDJmNWQxNzAwMDE0NDMxZjMiLCJvcmdpZCI6IiIsImVudiI6IiIsImV4cCI6MTcwMTM0NzQ2N30.2q7ENyEIXPRpQ1aF70jcF4XiQJs7YqOHwIogWXt1x5g", userId: "638de3302f5d1700014431f3")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

