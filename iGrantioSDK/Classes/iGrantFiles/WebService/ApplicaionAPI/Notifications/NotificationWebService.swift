
//
//  NotificationWebService.swift
//  iGrant
//
//  Created by Ajeesh T S on 21/10/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit

class NotificationWebService: BaseWebService {

//    func notificationsList(){
//        self.url = baseUrl + "user/notifications"
//        GET()
//    }
//    
//    func notificationsListLoadMore(apiUrl : String){
//        self.url = apiUrl
//        GET()
//    }
//    
//    func notificationDetailsList(iD : String){
//        self.url = baseUrl + "user/notifications/" + iD + "/action"
//        GET()
//    }
//    
//    func notificationRead(iD : String){
//        self.url = baseUrl + "user/notifications/" + iD
//        PATCH()
//    }
    
    func consentHistoryList(){
        self.url = baseUrl + "user/consenthistory"
        GET()
    }
    
    func consentHistoryListWith(OrgID: String){
        self.url = baseUrl + "user/consenthistory?orgid=" + OrgID
        GET()
    }
    
    func consentHistoryListWith(startDate: String, endDate: String){
        self.url = baseUrl + "user/consenthistory?startDate=" + startDate + "&endDate=" + endDate
        GET()
    }
    
    func consentHistoryListLoadMore(apiUrl : String){
        self.url = apiUrl
        GET()
    }
}
