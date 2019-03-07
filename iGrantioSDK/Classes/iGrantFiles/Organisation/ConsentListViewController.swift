//
//  ConsentListViewController.swift
//  iGrant
//
//  Created by Ajeesh T S on 29/06/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

class ConsentListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var policyBtn: UIButton!
    @IBOutlet weak var disAllowAllBtn: UIButton!
    @IBOutlet  var disAllowAllBtnHeightCostrint: NSLayoutConstraint!


    var organisaionDeatils : OrganisationDetails?
    var purposeInfo : Purpose?
    var consentslist : [ConsentDetails]?
    var consentslistInfo : ConsentListingResponse?
    var isNeedToRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = purposeInfo?.descriptionField
        tableView.tableFooterView = UIView()
        policyBtn.showRoundCorner(roundCorner: 3.0)
        policyBtn.layer.borderColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1).cgColor
        policyBtn.layer.borderWidth = 0.5
        addRefershNotification()
        callConsentListApi()
        manageDisallowButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managePolicyButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedToRefresh == true{
            isNeedToRefresh = false
            callConsentListApi()
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func addRefershNotification(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(ConsentListViewController.consentValueModified),
                                       name: .consentChange,
                                       object: nil)
    }
    
    
    func managePolicyButton(){
        if let url = self.consentslistInfo?.consents.purpose.policyURL{
            if url.isValidString{
               policyBtn.isHidden = false
            }else{
                policyBtn.isHidden = true
            }
        }else{
            policyBtn.isHidden = true
        }
    }
   
    func manageDisallowButton(){
        
        if self.consentslistInfo?.consents.purpose.lawfulUsage == false{
            if consentslistInfo?.consents.count.consented != nil{
                if (consentslistInfo?.consents.count.consented )! < 1{
                    disAllowAllBtn.isHidden = true
                    disAllowAllBtnHeightCostrint.constant = 0
                }else{
                    disAllowAllBtn.isHidden = false
                    disAllowAllBtnHeightCostrint.constant = 45
                }
            }
        }else{
            disAllowAllBtn.isHidden = true
            disAllowAllBtnHeightCostrint.constant = 0
        }
       
    }
    
    @objc func consentValueModified(){
        isNeedToRefresh = true
    }
    
    @IBAction func policyBtnClicked(){
        if let url = self.consentslistInfo?.consents.purpose.policyURL{
            if url.isValidString{
                let webviewVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewViewController
                webviewVC.urlString = url
                self.navigationController?.pushViewController(webviewVC, animated: true)
            }else{
                self.showErrorAlert(message: "Invalid URL")
            }
        }

    }
    
    @IBAction func disallowallBtnClicked(){
        showConfirmationAlert()
    }
    
    func callConsentListApi(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.consentList(orgId: (self.organisaionDeatils?.organization.iD)!, purposeId: (self.purposeInfo?.iD)!, consentId: (self.organisaionDeatils?.consentID)!)
    }
    
    func showConfirmationAlert(){
        let alerController = UIAlertController(title: Constant.AppSetupConstant.KAppName, message: NSLocalizedString("Are you sure you want to disallow all ?", comment: ""), preferredStyle: .alert)
        alerController.addAction(UIAlertAction(title: NSLocalizedString("Disallow All", comment: ""), style: .destructive, handler: {(action:UIAlertAction) in
            self.calldisallowAllApi()
        }));
        alerController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(action:UIAlertAction) in
        }));
        present(alerController, animated: true, completion: nil)

    }
    
    func calldisallowAllApi(){
        self.addLoadingIndicator()
        let serviceManager = OrganisationWebServiceManager()
        serviceManager.managerDelegate = self
        let value = "DisAllow"
        NotificationCenter.default.post(name: .consentChange, object: nil)
        serviceManager.updatePurpose(orgId: (self.organisaionDeatils?.organization.iD)!, consentID:  (self.organisaionDeatils?.consentID)!, attributeId: "", purposeId: (purposeInfo?.iD)!, status: value)
    }
   
}

extension ConsentListViewController:WebServiceTaskManagerProtocol{
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?)){
        self.removeLoadingIndicator()
        
        if response.error != nil{
            self.showErrorAlert(message: (response.error)!)
            return
        }
        
        if let serviceManager = manager as? OrganisationWebServiceManager{
            if serviceManager.serviceType == .AllowAlConsent{
//                self.callOrganisationDetailsApi()
            }
            else if serviceManager.serviceType == .UpdatePurpose{
                disAllowAllBtn.isHidden = true
                disAllowAllBtnHeightCostrint.constant = 0
                callConsentListApi()
            }
        }
        
        if let data = response.data?.responseModel as? ConsentListingResponse {
           self.consentslistInfo = data
            self.consentslist = data.consents.consentslist
            self.tableView.reloadData()
            manageDisallowButton()
            managePolicyButton()
        }
    }
    
}



extension  ConsentListViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if consentslist == nil{
            return 0
        }else{
            return (consentslist?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let consentCell = tableView.dequeueReusableCell(withIdentifier:"ConsentCell",for: indexPath) as! ConsentTableViewCell
        consentCell.consentInfo = consentslist?[indexPath.row]
        consentCell.showData()
        if self.consentslistInfo?.consents.purpose.lawfulUsage == false{
            
        }else {
            
        }
        return consentCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.consentslistInfo?.consents.purpose.lawfulUsage == false{
            let consentVC = Constant.getStoryboard(vc: self.classForCoder).instantiateViewController(withIdentifier: "ConsentVC") as! ConsentViewController
            consentVC.consent = consentslist?[indexPath.row]
            consentVC.orgID = self.consentslistInfo?.orgID
            consentVC.purposeDetails = self.consentslistInfo
            self.navigationController?.pushViewController(consentVC, animated: true)
        }
    }
    
}

