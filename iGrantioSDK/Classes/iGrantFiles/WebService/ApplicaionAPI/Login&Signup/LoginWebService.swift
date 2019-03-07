//
//  LoginWebService.swift
//  DocuTRUST
//
//  Created by Ajeesh Thankachan on 17/05/18.
//  Copyright © 2018 Marlabs. All rights reserved.
//

import UIKit

class LoginWebService: BaseWebService {
    func callLoginService(){
        self.url = baseUrl + "users/login"
        POST()
    }
}
