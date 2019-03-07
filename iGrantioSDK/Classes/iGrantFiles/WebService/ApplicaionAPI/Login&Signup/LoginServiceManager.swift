//
//  LoginServiceManager.swift
//
//  Created by Ajeesh Thankachan on 17/05/18.
//

import UIKit

enum LoginServiceType {
    case Login
    case ForgotPwd
    case SignUp
    case UpdateProfileImage
    case UpdateProfileInfo
    case ChangePassword
    case ValidEmail
    case ValidPhoneNumber
    case GenarateOTP
    case VerifyOTP
    case UpdateDeviceToken
}

class LoginServiceManager: BaseWebServiceManager {
    var newPassword = ""
    var apiSequenceNumber = 0
    var deviceTokenStr = ""
    var serviceType = LoginServiceType.Login
    deinit{
        self.managerDelegate = nil
    }
    
    func loginService(uname:String, pwd:String){
        self.serviceType = .Login
        DispatchQueue.global().async{
            let loginService = LoginWebService()
            loginService.delegate = self
            loginService.parameters =  ["username": uname as AnyObject, "password": pwd as AnyObject]
            loginService.callLoginService()
        }
    }
}


extension LoginServiceManager : BaseServiceDelegates {
    func didSuccessfullyReceiveData(response:RestResponse?){
        DispatchQueue.global().async {
            let responseData = response!.response!
            if responseData["errorCode"].string != nil{
                var errorMSg = ""
                if let msg = responseData["errorMsg"].string{
                    errorMSg = msg
                }
                DispatchQueue.main.async {
                    self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: errorMSg))
                    return
                }
            }else{
                self.handleLoginResponse(response: response)
            }
        }
        
    }
    
    func didFailedToReceiveData(response:RestResponse?){
        self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: response?.message))
    }
    
}


extension LoginServiceManager {
    func handleLoginResponse(response:RestResponse?){
        let responseData = response!.response!
        DispatchQueue.global().async {
            if let data = responseData["access_token"].string {
                Constant.Userinfo.currentUser.setToken(value: data)
            }
            if let data = responseData["userId"].string {
                Constant.Userinfo.currentUser.setUserId(value: data)
            }
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
    
    func handleFogotPasswordResponse(response:RestResponse?){
        let responseData = response!.response!
        if let msg = responseData["msg"].string{
            response?.message = msg
        }
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
            }
        }
    }
}


