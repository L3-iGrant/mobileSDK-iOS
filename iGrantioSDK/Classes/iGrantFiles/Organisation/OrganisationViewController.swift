
//
//  OrganisationViewController.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit
import ExpandableLabel
import SafariServices

class OrganisationViewController: BaseViewController {
    @IBOutlet weak var orgTableView: UITableView!
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet var topConstraint : NSLayoutConstraint!
    @IBOutlet var topBarItemConstraint : NSLayoutConstraint!

    var organisaionDeatils : OrganisationDetails?
    var organisationId = ""
    var isNeedToRefresh = false
    var overViewCollpased = true
    let popover = iGrant_Popover()

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(OrganisationViewController.consentValueModified),
                                       name: .consentChange,
                                       object: nil)
        setupUI()
        callOrganisationDetailsApi()
        // Do any additional setup after loading the view.
    }

    func setupUI(){
        if UIDevice.current.hasNotch {
            topConstraint.constant = -45.0
            topBarItemConstraint.constant = -15.0
        }
        
        customiseNavigationBar()
        orgTableView.estimatedRowHeight = 52.0
        self.orgTableView.rowHeight = UITableView.automaticDimension
        orgTableView.tableFooterView = UIView()
        backBtn.layer.cornerRadius =  backBtn.frame.size.height/2
        moreBtn.layer.cornerRadius =  moreBtn.frame.size.height/2
    }
    
    func customiseNavigationBar(){
//        self.navTitleLbl.text = "iGrant.io"
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar .lt_setBackgroundColor(backgroundColor: UIColor.clear)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = UIColor.clear
//         self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if isNeedToRefresh == true{
            isNeedToRefresh = false
            callOrganisationDetailsApi()
        }
    }
    
    func callOrganisationDetailsApi(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.getOrganisationDetails(orgId: self.organisationId)
    }
    
    @IBAction func backButtonClicked(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonClicked() {
        self.showPopOver()
    }
    
    @IBAction func allowAllButtonClicked(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.allowAllConsentOfOrganisation(orgId: self.organisationId)
    }
    
    @objc func consentValueModified(){
        isNeedToRefresh = true
    }
    
    func showPopOver(){
        let popOverview = OrgPopOver.instanceFromNib(vc: self.classForCoder)

        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 60)
        
        popOverview.privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        
        popOverview.downloadDataButton.addTarget(self, action: #selector(tappedOnDownloadData), for: .touchUpInside)
        
        popOverview.forgetMeButton.addTarget(self, action: #selector(tappedOnForgetMeButton), for: .touchUpInside)
        
//        popover.arrowSize = CGSize.init(width: 15, height: 20)
        popover.show(popOverview, point: startPoint)
    }

    @objc func showPrivacyPolicy() {
        popover.dismiss()
        if let privacyPolicy = self.organisaionDeatils?.organization.privacyPolicy {
            if self.verifyUrl(urlString: privacyPolicy) {
                let safariVC = SFSafariViewController(url: NSURL(string: privacyPolicy)! as URL)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            } else {
                self.showWarningAlert(message: Constant.Alert.KPromptMsgNotConfigured)
            }
        }
    }
    
    @objc func tappedOnDownloadData() {
        // create the alert
        popover.dismiss()
        let alert = UIAlertController(title: NSLocalizedString("Download Data", comment: ""), message: NSLocalizedString("A request to download data has been submitted. We will respond to you shortly.", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tappedOnForgetMeButton() {
        popover.dismiss()
        // create the alert
        let alert = UIAlertController(title: NSLocalizedString("Forget Me", comment: ""), message: NSLocalizedString("A request for deleting your data has been submitted. We will process your request shortly.", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
}

extension OrganisationViewController:WebServiceTaskManagerProtocol{
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)){
        self.removeLoadingIndicator()
        
        if response.error != nil{
            self.showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager{
            if serviceManager.serviceType == .AllowAlConsent{
               self.callOrganisationDetailsApi()
            }
            else if serviceManager.serviceType == .UpdatePurpose{
                self.callOrganisationDetailsApi()
            }
        }
        
        if let data = response.data?.responseModel as? OrganisationDetails {
            //                if data.productList != nil{
            //                    self.productList.append(contentsOf: data.productList!)
            //                }
            self.organisaionDeatils = data
            self.orgTableView.reloadData()
        }
    }
    
}

extension  OrganisationViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if organisaionDeatils?.purposeConsents != nil{
            if (organisaionDeatils?.purposeConsents.count)! > 0{
                return 3
            }else{
                return 1
            }
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2

        }
        else if section == 1{
            return 1
        }
        else{
            if (organisaionDeatils?.purposeConsents.count)! > 0{
                return  (organisaionDeatils?.purposeConsents.count)!
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0{
            if indexPath.row == 0{
                return 235
            }else{
                return UITableView.automaticDimension
            }
        }
        else if indexPath.section == 1{
            return 42
        }
        else{
            return 80
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if  indexPath.section == 0{
            if indexPath.row == 0{
                let orgCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedImageCellID,for: indexPath) as! OrgImageTableViewCell
                orgCell.orgData = organisaionDeatils?.organization
                    orgCell.showData()
                return orgCell

            }else{
                let orgOverViewCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedOverViewCellID,for: indexPath) as! OrgOverViewTableViewCell
//                orgOverViewCell.overViewLbl.text = organisaionDeatils?.organization?.descriptionField
                
                orgOverViewCell.overViewLbl.delegate = self
                orgOverViewCell.layoutIfNeeded()
                orgOverViewCell.overViewLbl.shouldCollapse = true

                if overViewCollpased == true{
//                    orgOverViewCell.overViewLbl.collapsed = overViewCollpased
//                    orgOverViewCell.overViewLbl.numberOfLines = 3
                    orgOverViewCell.overViewLbl.collapsed = true

                }else{
                    orgOverViewCell.overViewLbl.collapsed = false
//                    orgOverViewCell.overViewLbl.numberOfLines = 0
                }
                orgOverViewCell.overViewLbl.textReplacementType = .word
                if organisaionDeatils?.organization?.descriptionField != nil{
                    let desc = (organisaionDeatils?.organization?.descriptionField)!
                    orgOverViewCell.overViewLbl.text = desc
//                    orgOverViewCell.overViewLbl.setHTMLFromString(text: "Aksjdh khaksjdh ksa dkhksadh  khadkjhsa kd kahsdkjashd kah dskh sakdh \n askdh kasd kadkhsakjdh ksajhd  kahsdkhsakjdhksa hdksha kdhaskj d \n \n akdhskjdhkasdh kasdhkjashdkjhsa dkashdkjsad ksahdkjashd ksa hdksa ksahdkjsahdkjsahdkjhsakjdhkasjhdkjsahd ksajhdksah dkhsakjdh ksajdksah dksadkhskajhd kjsahdkshakd h kashdk\n dashgdashgdgsadggasdgj")
//                    orgOverViewCell.overViewLbl.text = "Aksjdh khaksjdh ksa dkhksadh  khadkjhsa kd kahsdkjashd kah dskh sakdh \n askdh kasd kadkhsakjdh ksajhd  kahsdkhsakjdhksa hdksha kdhaskj d \n \n akdhskjdhkasdh kasdhkjashdkjhsa dkashdkjsad ksahdkjashd ksa hdksa ksahdkjsahdkjsahdkjhsakjdhkasjhdkjsahd ksajhdksah dkhsakjdh ksajdksah dksadkhskajhd kjsahdkshakd h kashdk\n dashgdashgdgsadggasdgj"
                    //                    cell.descriptionLbl.from(html: desc)
                }
                return orgOverViewCell
            }
        }
        else if indexPath.section == 1{
            let headerCell = tableView.dequeueReusableCell(withIdentifier:Constant.CustomTabelCell.KOrgDetailedConsentHeaderCellID,for: indexPath)
            return headerCell
        }
        else{
            let consentCell = tableView.dequeueReusableCell(withIdentifier:"PurposeCell",for: indexPath) as! UsagePurposeTableViewCell
            consentCell.consentInfo = organisaionDeatils?.purposeConsents[indexPath.row]
            consentCell.delegate = self
            consentCell.showData()
            return consentCell
        }

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 2{
            let consentVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "ConsentListVC") as! ConsentListViewController
            consentVC.organisaionDeatils = self.organisaionDeatils
            consentVC.purposeInfo = organisaionDeatils?.purposeConsents[indexPath.row].purpose
            
            self.navigationController?.pushViewController(consentVC, animated: true)
        }
    }
    
}
//updatePurpose

extension OrganisationViewController: ExpandableLabelDelegate ,OrganisationPurposeCellDelegate{
    
    func purposeSwitchValueChanged(status:Bool,purposeInfo:PurposeConsent?,cell:UsagePurposeTableViewCell){
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        var alrtMsg = "Are you sure you want to allow?"
        var value = "Allow"
        var titleStr = "Allow"
        if status == false{
           alrtMsg = "Are you sure you want to disallow?"
            value = "DisAllow"
            titleStr = "Disallow"
        }
        
        let alerController = UIAlertController(title: Constant.AppSetupConstant.KAppName, message:alrtMsg , preferredStyle: .alert)
        if status == false{
            alerController.addAction(UIAlertAction(title: titleStr, style: .destructive, handler: {(action:UIAlertAction) in
                self.addLoadingIndicator()
                serviceManager.updatePurpose(orgId: (self.organisaionDeatils?.organization.iD)!, consentID:  (self.organisaionDeatils?.consentID)!, attributeId: "", purposeId: (purposeInfo?.purpose.iD)!, status: value)
            }));
            alerController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));

        }else{
            alerController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: {(action:UIAlertAction) in
                cell.statusSwitch.isOn = !cell.statusSwitch.isOn
            }));

            alerController.addAction(UIAlertAction(title: value, style: .default, handler: {(action:UIAlertAction) in
                self.addLoadingIndicator()
                serviceManager.updatePurpose(orgId: (self.organisaionDeatils?.organization.iD)!, consentID:  (self.organisaionDeatils?.consentID)!, attributeId: "", purposeId: (purposeInfo?.purpose.iD)!, status: value)
            }));

        }
        present(alerController, animated: true, completion: nil)
        

    }

    func willExpandLabel(_ label: ExpandableLabel){
//        label.collapsed = false
        overViewCollpased = false
        self.orgTableView.reloadData()
    }
    
    func didExpandLabel(_ label: ExpandableLabel){
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel){
    }
    
    func didCollapseLabel(_ label: ExpandableLabel){
//        label.collapsed = true
        overViewCollpased = true

        self.orgTableView.reloadData()
    }
}

extension OrganisationViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
