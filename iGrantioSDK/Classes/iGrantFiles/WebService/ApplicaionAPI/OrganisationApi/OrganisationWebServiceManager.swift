//
//  OrganisationWebServiceManager.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

enum OrganizationApiType {
    case NonAddedOrgList
    case AddNewOrg
    case OrgDetails
    case RemoveOrg
    case AllowAlConsent
    case SubscribedAndSuggestions
    case SearchOrg
    case UpdateConsent
    case PurposeList
    case UpdatePurpose
    
}

class WebServiceTaskManager: NSObject {
    var managerDelegate : WebServiceTaskManagerProtocol?
    deinit {
        self.managerDelegate = nil
    }
    
}

class OrganisationWebServiceManager: WebServiceTaskManager {
    var serviceType = OrganizationApiType.NonAddedOrgList
    let searchService = OrganisationWebService()
    var organisationId = ""
    var organisationType : String?
    var searchOrganisationInputStr = ""
    var consentDictionary = [String: AnyObject]()
    var consentId = ""

    
    func getNonAddedOrganisationList(){
        serviceType = .NonAddedOrgList
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.nonAddedOrganisationList()
        }
    }
    
    func getSubscribedAndSuggestionsOrganisationList(orgTypeId : String){
        serviceType = .SubscribedAndSuggestions
        organisationType = orgTypeId
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.getSubscribedOrgnaisationList(categoryId: orgTypeId)
        }
    }

    func getOrganisationDetails(orgId : String){
        serviceType = .OrgDetails
        organisationId = orgId
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.organisationDetails(orgId: orgId)
        }
    }
    
    func consentNewOrganisation(orgId : String){
        organisationId = orgId
        serviceType = .AddNewOrg
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.addOrganisation(orgId: orgId)
        }
    }
    
    
    func consentList(orgId : String,purposeId:String,consentId : String ){
        organisationId = orgId
        serviceType = .PurposeList
        DispatchQueue.global().async {
            self.searchService.delegate = self
            var userId  =  ""
            if Constant.Userinfo.currentUser.iGrantUserID != ""{
                userId =   Constant.Userinfo.currentUser.iGrantUserID 
            }
            let urlPart = "/consents/" + consentId + "/purposes/" + purposeId
            self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userId + urlPart
            self.searchService.GET()
        }
    }
    
    func removeOrganisation(orgId : String){
        organisationId = orgId
        serviceType = .RemoveOrg
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.removeOrganisation(orgId: orgId)
        }
    }
    
    func allowAllConsentOfOrganisation(orgId : String){
        organisationId = orgId
        serviceType = .AllowAlConsent
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.allowAllConsent(orgId: orgId)
        }
    }
    
    func searchOrganisation(org : String,orgType:String?){
        searchOrganisationInputStr = org
        organisationType = orgType
        serviceType = .SearchOrg
        DispatchQueue.global().async {
            self.searchService.delegate = self
            self.searchService.searchOrg(input: org, typeId: orgType)
        }
    }
    
    func updateConsent(orgId : String,consentID : String,attributeId : String,purposeId:String,valuesDict:[String: AnyObject]){
        organisationId = orgId
        serviceType = .UpdateConsent
        consentId = consentID
        consentDictionary = valuesDict
        DispatchQueue.global().async {
            self.searchService.delegate = self
            var userId  =  ""
            if Constant.Userinfo.currentUser.iGrantUserID != ""{
                userId =   Constant.Userinfo.currentUser.iGrantUserID 
            }
            let urlPart = "/consents/" + consentID + "/purposes/" + purposeId + "/attributes/" + attributeId
            self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userId + urlPart
            self.searchService.parameters = valuesDict
            self.searchService.PATCH()
//            self.searchService.changeConsent(orgId: orgId, consentID: consentID, parameter: valuesDict)
        }
    }
    
    
    func updatePurpose(orgId : String,consentID : String,attributeId : String,purposeId:String,status:String){
            organisationId = orgId
            serviceType = .UpdatePurpose
            consentId = consentID
            DispatchQueue.global().async {
                self.searchService.delegate = self
                var userId  =  ""
                if Constant.Userinfo.currentUser.iGrantUserID != ""{
                    userId =   Constant.Userinfo.currentUser.iGrantUserID 
                }
                let urlPart = "/consents/" + consentID + "/purposes/" + purposeId + "/status"
                self.searchService.url = baseUrl + "organizations/" + orgId + "/users/" + userId + urlPart
                self.searchService.parameters = ["consented" : status as AnyObject]
                self.searchService.POST()
                //            self.searchService.changeConsent(orgId: orgId, consentID: consentID, parameter: valuesDict)
            }
//        https://api.igrant.dev/v1/organizations/5b2137c93fee23000194d8ea/users/5b2135a23fee23000194d8e3/consents/5b3dca30c8c87f0001322c48/purposes/5b3dc983c8c87f0001322c45/status
    }
    
    func reCallFailedApi(){
        switch(serviceType) {
        case .NonAddedOrgList:getNonAddedOrganisationList()
        case .AddNewOrg:consentNewOrganisation(orgId: self.organisationId)
        case .OrgDetails:getOrganisationDetails(orgId: self.organisationId)
        case .RemoveOrg:removeOrganisation(orgId: self.organisationId)
        case .AllowAlConsent:allowAllConsentOfOrganisation(orgId: self.organisationId)
        case .SubscribedAndSuggestions: let orgTypTmp : String = organisationType!
            getSubscribedAndSuggestionsOrganisationList(orgTypeId: orgTypTmp)
        case .SearchOrg :searchOrganisation(org: searchOrganisationInputStr, orgType: organisationType)
        case .UpdateConsent: break
//        updateConsent(orgId: organisationId, consentID: consentId, valuesDict: consentDictionary)
        case .PurposeList : break
        case .UpdatePurpose : break
        }
    }
    


}


extension OrganisationWebServiceManager : BaseServiceDelegates {
    func didSuccessfullyReceiveData(response:RestResponse?){
        //let responseData = response!.response!
        if response?.serviceType == .ReCallLogin{
            Constant.Userinfo.currentUser.deleteData()
            
        }else{
            switch(serviceType) {
            case .NonAddedOrgList:handleNonAddedOrgsResponse(response: response)
            case .AddNewOrg: break//handleAddNewOrgResponse(response: response)
            case .OrgDetails: handleOrgDetailsResponse(response: response)
            case .RemoveOrg: break//handleRemoveOrgResponse(response: response)
            case .AllowAlConsent: handleAlloAllConsentResponse(response: response)
            case .SubscribedAndSuggestions: break// handleSubscribedAndSuggestionResponse(response: response)
            case .SearchOrg :break//handleSearchResponse(response: response)
            case .UpdateConsent: handleUpdateConsentResponse(response: response)
            case .PurposeList : handleConsentListResponse(response: response)
            case .UpdatePurpose : handleUpdatePuposeResponse(response: response)
            }
        }
        
        
        
      
    }
    
    func didFailedToReceiveData(response:RestResponse?){
        if response?.message == Constant.AppSetupConstant.KTokenExpired{
           Constant.Userinfo.currentUser.deleteData()
        }else{
            self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: response?.message))
        }
    }

}


extension OrganisationWebServiceManager {
    func handleNonAddedOrgsResponse(response:RestResponse?){
        let responseData = response!.response!
        DispatchQueue.global().async {
            if let orgs = responseData["Organizations"].array {
                var orgList = [Organization]()
                for org in orgs {
                    let orgObj = Organization.init(fromJson: org)
                    orgList.append(orgObj)
                }
                response?.responseModel = orgList as AnyObject?
            }
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
           
        }
    }
    
    func handleOrgDetailsResponse(response:RestResponse?){
        let responseData = response!.response!
        DispatchQueue.global().async {
            let orgDetails = OrganisationDetails(fromJson:responseData)
            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }

    
    func handleAlloAllConsentResponse(response:RestResponse?){
        //        let responseData = response!.response!
        DispatchQueue.global().async {
            //            let orgDetails = OrganisationDetails(fromJson:responseData)
            //            response?.responseModel = orgDetails as AnyObject?
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleUpdateConsentResponse(response:RestResponse?){
        //let responseData = response!.response!
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleUpdatePuposeResponse(response:RestResponse?){
       // let responseData = response!.response!
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    
    
   func handleConsentListResponse(response: RestResponse?){
        let responseData = response!.response!
        let consentListinfo = ConsentListingResponse(fromJson:responseData)
        response?.responseModel = consentListinfo as AnyObject?
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    

}
