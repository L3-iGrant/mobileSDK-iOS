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
    var orgId: String?
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetToLoginScreen), name: Notification.Name("ResetToLogin"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func resetToLoginScreen() {
        UIApplication.topViewController()?.dismiss(animated: false, completion: {
            let loginVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginNav = UINavigationController.init(rootViewController: loginVC)
            loginVC.orgId = self.orgId ?? ""
            loginNav.modalPresentationStyle = .fullScreen

            UIApplication.topViewController()?.present(loginNav, animated: true, completion: nil)
        })
    }
    
    public func show(organisationToken: String, userToken: String) {
        orgId = organisationToken
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
