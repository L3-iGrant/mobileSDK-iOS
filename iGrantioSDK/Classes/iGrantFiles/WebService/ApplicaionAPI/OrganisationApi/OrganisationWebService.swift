
//
//  OrganisationWebService.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

enum RequestType {
    case DownloadData
    case ForgetMe
}

class OrganisationWebService: BaseWebService {
    
    func nonAddedOrganisationList(){
        self.url = baseUrl + "GetOrgsToSubscribe"
        GET()
    }
    
    func getSubscribedOrgnaisationList(categoryId : String){
//        var userId  =  ""
//        if  Constant.Userinfo.currentUser.iGrantUserID != ""{
//            userId =   Constant.Userinfo.currentUser.iGrantUserID
//        }
        self.url = baseUrl + "GetUserOrgsAndSuggestionsByType" + "?typeID=" + categoryId
        GET()
    }
    
    func organisationDetails(orgId : String){
//        var userId  =  ""
//        if Constant.Userinfo.currentUser.iGrantUserID != ""{
//            userId =   Constant.Userinfo.currentUser.iGrantUserID
//        }
        self.url = baseUrl + "GetUserOrgsAndConsents" + "?orgID=" + orgId
        GET()
    }
    
    func addOrganisation(orgId : String){
        var userId  =  ""
        if Constant.Userinfo.currentUser.iGrantUserID != ""{
            userId =   Constant.Userinfo.currentUser.iGrantUserID
        }
        self.url = baseUrl + "organizations/" + orgId + "/users"
        self.parameters = ["UserID": userId as AnyObject]
        POST()
    }
    
    func removeOrganisation(orgId : String){
        var userId  =  ""
        if Constant.Userinfo.currentUser.iGrantUserID != "" {
            userId =   Constant.Userinfo.currentUser.iGrantUserID
        }
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userId
        DELETE()
    }
    
    func allowAllConsent(orgId : String){
        var userId  =  ""
        if Constant.Userinfo.currentUser.iGrantUserID != "" {
            userId =   Constant.Userinfo.currentUser.iGrantUserID
        }
        self.url = baseUrl + "UpdateAllConsents/" + userId + "?orgID=" + orgId + "&consented=Disallow"
        POST()
    }
    
    func searchOrg(input : String,typeId : String?){
        var userId  =  ""
        if Constant.Userinfo.currentUser.iGrantUserID != "" {
            userId =   Constant.Userinfo.currentUser.iGrantUserID
        }
        let urlString = baseUrl + "organizations/" + "search?name=" + input
        if typeId != nil{
            let orgTypeID : String = typeId!
            self.url = urlString + "&type=" + orgTypeID + "&userID=" + userId
            
        }else{
            self.url = urlString + "&userID=" + userId
        }
        GET()
    }
    
    func changeConsent(orgId : String,consentID : String,parameter:[String: AnyObject]){
        var userId  =  ""
        if Constant.Userinfo.currentUser.iGrantUserID != "" {
            userId =   Constant.Userinfo.currentUser.iGrantUserID
        }
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userId + "/consents/" + consentID
        self.parameters = parameter
        self.parameters.updateValue(consentID as AnyObject, forKey: "consentID")
        PATCH()
    }

    func requestDownloadData(orgId: String) {
        
        self.url = baseUrl + "user/organizations/" + orgId + "/data-download"
        POST()
    }
    
    func requestForgetMe(orgId: String) {
        
        self.url = baseUrl + "user/organizations/" + orgId + "/data-delete"
        POST()
    }
    
    func getDownloadDataStatus(orgId: String) {
        
        self.url = baseUrl + "user/organizations/" + orgId + "/data-download/status"
        GET()
    }
    
    func getForgetMeStatus(orgId: String) {
        
        self.url = baseUrl + "user/organizations/" + orgId + "/data-delete/status"
        GET()
    }
    
    func cancelRequest(orgId: String, requestID: String, type: RequestType) {
        if type == RequestType.DownloadData {
            self.url = baseUrl + "user/organizations/" + orgId + "/data-download/" + requestID + "/cancel"
        } else {
            self.url = baseUrl + "user/organizations/" + orgId + "/data-delete/" + requestID + "/cancel"
        }
        POST()
    }
    
    func getRequestedStatus(orgId: String) {
        self.url = baseUrl + "user/organizations/" + orgId + "/data-status"
        GET()
    }
    
    
}
