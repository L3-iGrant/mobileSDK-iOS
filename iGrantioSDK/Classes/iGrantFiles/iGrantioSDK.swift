//
//  iGrantViewController.swift
//  iGrantFrameworkFiles
//
//  Created by Mohamed Rebin on 17/02/19.
//  Copyright © 2019 iGrant. All rights reserved.
//

import UIKit

public class iGrantioSDK: UIViewController {

    public static var shared = iGrantioSDK()
    var orgId: String?
    var userId: String?
    var hideBackButton = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetToLoginScreen), name: Notification.Name("ResetToLogin"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    func getOrgVC() -> OrganisationViewController{
        return Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "OrgDetailedVC") as? OrganisationViewController ?? OrganisationViewController()
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
    
    public func show(organisationId: String, apiKey: String, userId: String) {
        orgId = organisationId
        self.userId = userId
        if(!apiKey.isEmpty){
            let serviceManager = LoginServiceManager()
            serviceManager.getUserDetails()
            let data = apiKey.data(using: .utf8) ?? Data()
            _ = KeyChain.save(key: "iGrantioToken", data: data)
            
            let orgVC = getOrgVC()
                       orgVC.organisationId = organisationId
                       
                       let navVC = UINavigationController.init(rootViewController: orgVC)
                       navVC.modalPresentationStyle = .fullScreen
                       UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
            return;
        }
        
        if userId != "" {
            let orgVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "OrgDetailedVC") as! OrganisationViewController
            orgVC.organisationId = organisationId
            self.userId = userId
            let navVC = UINavigationController.init(rootViewController: orgVC)
            navVC.modalPresentationStyle = .fullScreen
            if !hideBackButton{
                
            }
            UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
        } else {
            let loginVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginNav = UINavigationController.init(rootViewController: loginVC)
            loginVC.orgId = organisationId
            self.userId = userId
            loginNav.modalPresentationStyle = .fullScreen
            if !hideBackButton{
                
            }
            UIApplication.topViewController()?.present(loginNav, animated: true, completion: nil)
        }
    }
    
    func showBackButton(){
        let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "orgback"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    public func iGrantRegisterForPushNotification (deviceToken: String){
        let serviceManager = LoginServiceManager()
        serviceManager.updateDeviceToken(deviceToken: deviceToken)
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
