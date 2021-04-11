
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
        self.url = baseUrl + "GetUserOrgsAndSuggestionsByType" + "?typeID=" + categoryId
        GET()
    }
    
    func getSubscribedOrgs(){
        self.url = baseUrl + "user/organizations"
        GET()
    }
    
    func organisationDetails(orgId : String){
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "users/" + userID + "/GetUserOrgsAndConsents" + "?orgID=" + orgId
        GET()
    }
    
    func addOrganisation(orgId : String, subKey: String?){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users"
        self.parameters = ["UserID": userID as AnyObject, "SubscribeKey" : subKey ?? ""] as [String : AnyObject]
        POST()
    }
    
    func getOrganisationSubscribeMethod(orgId : String) {
        self.url = baseUrl + "organizations/" + orgId + "/subscribe-method"
        GET()
    }
    
    func removeOrganisation(orgId : String){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userID
        DELETE()
    }
    
    func allowAllConsent(orgId : String){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "UpdateAllConsents/" + userID + "?orgID=" + orgId + "&consented=Disallow"
        POST()
    }
    
    func searchOrg(input : String,typeId : String?){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = iGrantioSDK.shared.userId ?? ""
        let urlString = baseUrl + "organizations/" + "search?name=" + input
        if typeId != nil{
            let orgTypeID : String = typeId!
            self.url = urlString + "&type=" + orgTypeID + "&userID=" + userID
            
        }else{
            self.url = urlString + "&userID=" + userID
        }
        GET()
    }
    
    func changeConsent(orgId : String,consentID : String,parameter:[String: AnyObject]){
//        var userId  =  ""
//        if  UserInfo.currentUser()?.userID != nil{
//            userId =  (UserInfo.currentUser()?.userID)!
//        }
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "organizations/" + orgId + "/users/" + userID + "/consents/" + consentID
        self.parameters = parameter
        self.parameters.updateValue(consentID as AnyObject, forKey: "consentID")
        PATCH()
    }

    func requestDownloadData(orgId: String) {
        let userID = iGrantioSDK.shared.userId ?? ""
//        self.url = baseUrl + "user/organizations/" + orgId + "/data-download"
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-download"
        POST()
    }
    
    func requestForgetMe(orgId: String) {
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-delete"
        POST()
    }
    
    func getDownloadDataStatus(orgId: String) {
        let userID = iGrantioSDK.shared.userId ?? ""
//        self.url = baseUrl + "user/organizations/" + orgId + "/data-download/status"
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-download/status"
        GET()
    }
    
    func acceptEulaConsent(orgId: String, parameters : [String: AnyObject]) {
        self.url = baseUrl + "user/organizations/" + orgId + "/eula"
        self.parameters = parameters
        POST()
    }
    
    func getForgetMeStatus(orgId: String) {
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-delete/status"
        GET()
    }
    
    func cancelRequest(orgId: String, requestID: String, type: RequestType) {
        let userID = iGrantioSDK.shared.userId ?? ""
        if type == RequestType.DownloadData {
             self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-download/" + requestID + "/cancel"
        } else {
            self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-delete/" + requestID + "/cancel"
        }
       POST()
    }
    
    func getRequestedStatus(orgId: String) {
        let userID = iGrantioSDK.shared.userId ?? ""
        self.url = baseUrl + "users/" + userID + "/organizations/" + orgId + "/data-status"
        GET()
    }
    
    func requestedStatusLoadMore(apiUrl : String){
        self.url = apiUrl
        GET()
    }
    
}
