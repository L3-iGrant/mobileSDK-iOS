
//
//  BaseWebServiceManager.swift
//  JomTumpang
//
//  Created by Ajeesh T S on 27/04/17.
//  Copyright © 2017 JomTumpang. All rights reserved.
//

import UIKit

let kResponseBaseKey = "data"

protocol WebServiceTaskManagerProtocol {
    
    /*******************************************************************************
     *  Function Name       : didFinishTask: manager: response
     *  Purpose             : delegate method to notify the controller about the completion
     status of the task assigned to the manager.
     *  Parametrs           : manager - the manager class from which the method is called.
     response - the response tuple of the task.
     data - the response data if any.
     error - error message to be displayed if any error occurs
     during the task performing.
     *  Return Values       : nil
     ********************************************************************************/
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:String?))
    
    
}


class BaseWebServiceManager: NSObject {

    var managerDelegate : WebServiceTaskManagerProtocol?
    deinit {
        self.managerDelegate = nil
    }
}
