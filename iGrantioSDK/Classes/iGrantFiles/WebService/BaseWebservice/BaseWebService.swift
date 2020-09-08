
//
//  BaseWebService.swift
//  FnB
//
//  Created by Ajeesh T S on 05/01/17.
//  Copyright © 2017 SimStream. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

//Production
//var baseUrl = "https://api.igrant.io/v1/"

//staging
//var baseUrl = "https://staging-api.igrant.io/v1/"

//demo
var baseUrl = "https://demo-api.igrant.io/v1/"
var baseUrl_V1 = "https://demo-api.igrant.io/v1.1/"

class RestResponse : NSObject {
    var response : JSON?
    var responseModel : AnyObject?
    var responseCode : Int?
    var responseHttpCode : Int?
    var responseDetail : AnyObject?
    var error : Error?
    var paginationIndex : NSMutableString?
    var requestData : AnyObject?
    var message : String?
    var serviceType = WebServiceType.None
}

class MultipartData: NSObject {
    var data: NSData
    var name: String
    var fileName: String
    var mimeType: String
    init(data: NSData, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        
    }
}

@objc protocol BaseServiceDelegates {
    //the service call was successful and the data is passed to the manager
    @objc optional func didSuccessfullyReceiveData(response:RestResponse?)
    
    //the service call was failed and the error message to be shown is
    //fetched and returned to the manager.
    @objc optional func didFailedToReceiveData(response:RestResponse?)
    
    @objc optional func imageUploadPrograss(prograssValue : Float)
    
}

enum WebServiceType {
    case None
    case ReCallLogin
}


class BaseWebService: NSObject {
    var serviceType = WebServiceType.None
    var delegate : BaseServiceDelegates?
    var url: String?
    var parameters = [String: AnyObject]()
    var uploadData: [MultipartData]?
    var header:[String : String]?
    var requestInfo : [String:String]?
    var errorMsg : String?
    
    
    func refreshToken() {
        let refreshToken : String = (UserInfo.currentUser()?.refreshToken)!
        self.parameters =  ["clientId": "igrant-ios-app" as AnyObject, "refreshToken": refreshToken as AnyObject]
        self.url = baseUrl + "user/token"
        self.POST()
    }

    func failureWithError(error: Error?) {
        let restResponse = RestResponse()
        restResponse.error = error
        restResponse.message = errorMsg
        restResponse.serviceType = self.serviceType
        delegate?.didFailedToReceiveData!(response: restResponse)
    }
    
    func successWithResponse(response:JSON?){
        let restResponse = RestResponse()
        restResponse.response = response
        restResponse.serviceType = self.serviceType
        restResponse.requestData = self.requestInfo as AnyObject?
        delegate?.didSuccessfullyReceiveData!(response: restResponse)
    }

    func GET(){
        if UserInfo.currentUser()?.token != nil{
            let token : String = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
        if let tokendata = KeyChain.load(key: "iGrantioToken") {
            let token = String(data: tokendata, encoding: .utf8) ?? ""
            let hearDict = ["Authorization":"ApiKey \(token)"]
            header = hearDict
        }
        
        Alamofire.request(url!, parameters: parameters, headers:header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    if let val = response.result.value {
                        let json = JSON(val)
                        self.successWithResponse(response: json)
                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    func POST() {
        if let data = uploadData {
            self.upload(data: data)
        }
        else {
            POST_normal()
        }
    }
    
    
    func POST_normal(){
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
        if let tokendata = KeyChain.load(key: "iGrantioToken") {
                   let token = String(data: tokendata, encoding: .utf8) ?? ""
                   let hearDict = ["Authorization":"ApiKey \(token)"]
                   header = hearDict
               }
        
        if serviceType == .ReCallLogin{
            header = nil
        }
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default , headers:header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    if let val = response.result.value {
                        let json = JSON(val)
                        self.successWithResponse(response: json)
                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
            }
    }
    
    
    
    
    func PUT(){
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        
         if let tokendata = KeyChain.load(key: "iGrantioToken") {
                   let token = String(data: tokendata, encoding: .utf8) ?? ""
                   let hearDict = ["Authorization":"ApiKey \(token)"]
                   header = hearDict
               }
        
        Alamofire.request(url!, method: .put, parameters: parameters,  encoding: JSONEncoding.default, headers:header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    if let val = response.result.value {
                        let json = JSON(val)
                        self.successWithResponse(response: json)
                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
        }
    }
    
    
    func PATCH(){
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            
            header = hearDict
        }else{
        }
        if let tokendata = KeyChain.load(key: "iGrantioToken") {
                   let token = String(data: tokendata, encoding: .utf8) ?? ""
                   let hearDict = ["Authorization":"ApiKey \(token)"]
                   header = hearDict
               }
        
        Alamofire.request(url!, method: .patch, parameters: parameters, encoding: JSONEncoding.default,headers:header
            )
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    if let val = response.result.value {
                        let json = JSON(val)
                        self.successWithResponse(response: json)
                    }
                case .failure(let error):
                    if let data = response.data, let utf8Text = String.init(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(utf8Text)")
                    }
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
        }
    }
    
    
    func DELETE(){
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        if let tokendata = KeyChain.load(key: "iGrantioToken") {
                   let token = String(data: tokendata, encoding: .utf8) ?? ""
                   let hearDict = ["Authorization":"ApiKey \(token)"]
                   header = hearDict
               }
        
        Alamofire.request(url!, method: .delete, headers:header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    if let val = response.result.value {
                        let json = JSON(val)
                        self.successWithResponse(response: json)
                    }
                case .failure(let error):
                    let json = JSON(response.data as Any)
                    if let errormsg = json["error_description"].string{
                        self.errorMsg = errormsg
                    }
                    if let errormsg = json["Message"].string{
                        self.errorMsg = errormsg
                    }
                    self.failureWithError(error: error)
                }
        }
    }
    
    
    func upload(data: [MultipartData]) {
        if UserInfo.currentUser()?.token != nil{
            let token : String  = (UserInfo.currentUser()?.token)!
            let hearDict = ["Authorization":"Bearer \(token)"]
            header = hearDict
        }else{
            header = nil
        }
        if let tokendata = KeyChain.load(key: "iGrantioToken") {
                   let token = String(data: tokendata, encoding: .utf8) ?? ""
                   let hearDict = ["Authorization":"ApiKey \(token)"]
                   header = hearDict
               }
        
        let urlRequest = try! URLRequest(url: url!, method: .post, headers: header)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in self.parameters {
                    if let valueString = value as? String {
                        multipartFormData.append(valueString.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                for data in self.uploadData! {
                    multipartFormData.append(data.data as Data, withName: data.name, fileName: data.fileName, mimeType: data.mimeType)
                }
        },
            with: urlRequest,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        let json = JSON(response.result.value as Any)
                        self.successWithResponse(response: json)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.failureWithError(error: encodingError)
                }
        }
        )
    }
}
