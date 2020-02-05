//
//  iGrantViewController.swift
//  iGrantFrameworkFiles
//
//  Created by Mohamed Rebin on 17/02/19.
//  Copyright © 2019 iGrant. All rights reserved.
//

import UIKit

public class iGrantViewController: UIViewController {

    public static var shared = iGrantViewController()
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    public func show(organisationToken: String, userToken: String) {
        if UserInfo.restoreSession() {
            let orgVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "OrgDetailedVC") as! OrganisationViewController
            orgVC.organisationId = organisationToken
            
            let navVC = UINavigationController.init(rootViewController: orgVC)
            navVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
        } else {
            let loginVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginNav = UINavigationController.init(rootViewController: loginVC)
            loginVC.orgId = organisationToken
            loginNav.modalPresentationStyle = .fullScreen

            UIApplication.topViewController()?.present(loginNav, animated: true, completion: nil)
        }
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
