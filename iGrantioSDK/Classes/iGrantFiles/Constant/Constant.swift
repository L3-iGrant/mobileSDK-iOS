//
//  Constant.swift
//  FnB
//
//  Created by Apple01 on 2/14/17.
//  Copyright © 2017 SimStream. All rights reserved.
//

import Foundation
import UIKit

struct Constant {

    static func getStoryboard(vc: AnyClass) -> UIStoryboard {
            print(vc)
        print(Bundle.init(for: vc))
        return UIStoryboard(name:"iGrant", bundle: Bundle.init(for: vc))
    }
    
    struct AppSetupConstant {
        static let KSavingUSerInfoUserDefaultKey = "UserSession"
        static let KAppName = "iGrant.io"
//        static let KTokenExpired = "Authorization failed"
        static let KTokenExpired = "Invalid token, Authorization failed"
    }
    
    
    /// This is an **ScreenSize** Constant.
    
    struct ScreenSize{
        
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct Userinfo {
        static var currentUser = Userinfo()
        private var token = "iGrantUserToken"
        private var userID = "iGrantUserId"
        var iGrantToken: String {
            return UserDefaults.standard.value(forKey: token) as? String ?? ""
        }
        
        var iGrantUserID: String {
            return UserDefaults.standard.value(forKey: userID) as? String ?? "5c18adb05430460001af6250"
        }
        
        func setToken(value: String) {
            UserDefaults.standard.set(value, forKey: token)
        }
        
        func setUserId(value: String) {
            UserDefaults.standard.set(value, forKey: userID)
        }
        
        var isUserAvailable: Bool {
            return UserDefaults.standard.value(forKey: token) != nil
        }
        
        func deleteData() {
            UserDefaults.standard.removeObject(forKey: token)
            UserDefaults.standard.removeObject(forKey: userID)
        }
    }
    //------------------------------------------------------------------------------------------------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DEVICE TYPE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //------------------------------------------------------------------------------------------------------------------------------------//
    
    struct DeviceType
    {
        
        static let IS_IPHONE_5s = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        
        static let IS_IPHONE_6p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        
         static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        
    }
    
    
    //------------------------------------------------------------------------------------------------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ COMMON UICOLORS USED~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //------------------------------------------------------------------------------------------------------------------------------------//
    
    struct Color {
        
        static let UI_COLOR_BORDER =  UIColor(red:0.70, green:0.71, blue:0.71, alpha:1.00).cgColor
        
        static let UI_COLOR_LOGINBTN_BORDER = UIColor(red:0.55, green:0.55, blue:0.56, alpha:1.00).cgColor
    }
    
    
    //------------------------------------------------------------------------------------------------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~COMMON ALERT MESSAGE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //------------------------------------------------------------------------------------------------------------------------------------//
    
    struct Alert {
        
        static let KPromptMsgEnterEmail = "Please enter Email"
        static let KPromptMsgEnterComment = "Please enter Comment"
        static let KPromptMsgEnterValidEmail = "Please enter valid email"
        static let KPromptMsgEnterAddress = "Please Enter Address"
        static let KPromptMsgEnterCity = "Please Enter City"
        static let KPromptMsgEnterCountry = "Please Enter Country"
        static let KPromptMsgEnterZipcode = "Please Enter Zipcode"
        static let KPromptMsgEnterMobileNumber = "Please Enter Mobile Number"
        static let KPromptMsgEnterValidMobileNumber = "Please Enter Valid Mobile Number"

        static let KPromptMsgEnterPassword = "Please Enter Password"
        static let KPromptMsgEnterNewPassword = "Please Enter New Password"
        static let KPromptMsgEnterOTP = "Please Enter OTP"

        static let KPromptMsgPasswordMismatch = "Password Mismatch"

        static let KPromptMsgEnterValidPassword = "Password should be atleast 6 characters"
        static let KPromptMsgEnterUserName = "Please Enter name"
        static let KPromptMsgEnterLastName = "Please Enter Last Name"
        static let KPromptMsgEnterFirstName = "Please Enter First Name"
        static let KPromptMsgEnterLandmark = "Please Enter Landmark"
        static let KPromptMsgEnterMessage = "Please enter the message"
        static let KPromptServerConectError = "Server connection error"
        
        static let KPromptMsgEnterStartDate = "Please select the start date."
        static let KPromptMsgEnterEndDate = "Please select the end date"
        static let KPromptMsgNotConfigured = "Not Configured"
        
    }

    struct CustomTabelCell{
        static let KMoreCellID = "moreCell"
        static let KProfileListCellID = "ListCell"
        static let KEventCellID = "EventCell"
        static let KProfileCellID = "UserProfileCell"
        static let KSubcribedHeaderCellID = "SubcribedHeaderCell"
        static let KAddOrgBtnCellID = "AddOrgBtnCell"
        static let KRecenlyAddOrgBtnCellID = "RecentlyAddedHeaderCell"
        static let KRecenlyAddOrgCellID = "RecentlyAddedOrgCell"
        static let KOrgTypeCellID = "OrganisationTypeTableViewCell"
        static let KOrgDetailedImageCellID = "ImageCell"
        static let KOrgDetailedOverViewCellID = "OverViewCell"
        static let KOrgDetailedConsentCellID = "ConsentCell"
        static let KOrgDetailedConsentHeaderCellID = "HeaderCell"
        static let KOrgDetailedConsentAllowCellID = "AllowCell"
        static let KOrgDetailedConsentDisAllowCellID = "DisallowCell"
        static let KOrgDetailedConsentAskMeCellID = "AskMeCell"
        static let KOrgSuggestionCellID = "SuggestionCell"


        
    }
   
}
