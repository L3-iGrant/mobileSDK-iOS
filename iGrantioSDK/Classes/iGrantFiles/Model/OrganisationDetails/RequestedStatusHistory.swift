//
//  RequestedStatusHistory.swift
//  iGrant
//
//  Created by Mohamed Rebin on 08/07/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import Foundation
import SwiftyJSON
class RequestedStatusHistory{
    
    var DataRequests : [RequestStatus]!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        DataRequests = [RequestStatus]()
        let DataRequestsArray = json["DataRequests"].arrayValue
        for DataRequestJson in DataRequestsArray{
            let value = RequestStatus(fromJson: DataRequestJson)
            DataRequests.append(value)
        }
    }
    
}
