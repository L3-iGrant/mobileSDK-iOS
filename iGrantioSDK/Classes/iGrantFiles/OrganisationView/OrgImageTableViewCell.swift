//
//  OrgImageTableViewCell.swift
//  iGrant
//
//  Created by Ajeesh T S on 25/03/18.
//  Copyright © 2018 iGrant.com. All rights reserved.
//

import UIKit
import Kingfisher

class OrgImageTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var orgImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoBgBtn: UIButton!
    @IBOutlet weak var gradiantView: UIView!
    @IBOutlet weak var gradiantViewTop: UIView!
    

    var orgData : Organization?
    override func awakeFromNib() {
        super.awakeFromNib()
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: gradiantView.frame.size.height)
//        let colorTop = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
//        let colorBottom = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25).cgColor
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradiantView.layer.insertSublayer(gradientLayer, at: 0)
//
//        let gradientLayerTop = CAGradientLayer()
//        gradientLayerTop.frame = CGRect.init(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: gradiantView.frame.size.height)
//        gradientLayerTop.colors = [colorBottom,colorTop]
//        gradiantViewTop.layer.insertSublayer(gradientLayerTop, at: 0)
        logoImageView.layer.cornerRadius =  logoImageView.frame.size.height/2
//        logoImageView.layer.borderWidth = 4
//        logoImageView.borderColor = UIColor.white
        
        logoBgBtn.layer.cornerRadius =  logoBgBtn.frame.size.height/2
//        logoBgBtn.layer.borderWidth = 4
//        logoImageView.borderColor = UIColor.clear


        
//        logoImageView.backgroundColor = UIColor.white
        

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(){
        self.nameLbl.text = self.orgData?.name
        self.locationLbl.text = self.orgData?.location
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("Bearer \(UserInfo.currentUser()?.token ?? "")", forHTTPHeaderField: "Authorization")
            if let tokendata = KeyChain.load(key: "iGrantioToken") {
                let token = String(data: tokendata, encoding: .utf8) ?? ""
                r.setValue("ApiKey \(token)", forHTTPHeaderField: "Authorization")
            }
            return r
        }

        if let imageUrl = self.orgData?.coverImageURL{
            let placeholder = UIImage(named: "Default_Coverimage", in: Constant.getResourcesBundle(vc: BaseViewController().classForCoder), compatibleWith: nil)

            self.orgImageView.kf.setImage(with: imageUrl, placeholder: placeholder, options: [.requestModifier(modifier)])
        }
        if let imageUrl = self.orgData?.logoImageURL{
            let placeholder = UIImage(named: "Tick_Transparent-Grey-2", in: Constant.getResourcesBundle(vc: BaseViewController().classForCoder), compatibleWith: nil)

            self.logoImageView.kf.setImage(with: imageUrl, placeholder: placeholder, options: [.requestModifier(modifier)])
        }
        
//        if let imageUrl = self.orgData?.coverImageURL{
//            var headers = [
//                "Authorization": "Bearer \(UserInfo.currentUser()?.token ?? "")"
//            ]
//
//            if let tokendata = KeyChain.load(key: "iGrantioToken") {
//                       let token = String(data: tokendata, encoding: .utf8) ?? ""
//                       let hearDict = ["Authorization":"ApiKey \(token)"]
//                       headers = hearDict
//                   }
//
//            let request = NSMutableURLRequest(url: imageUrl,
//                                              cachePolicy: .useProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.httpMethod = "GET"
//            request.allHTTPHeaderFields = headers
//
//            let session = URLSession.shared
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//                if (error != nil) {
//                    print(error!)
//                } else {
//                    if data != nil {
//                        if let image = UIImage.init(data: data!) {
//                            DispatchQueue.main.async {
//                                self.orgImageView.image = image
//                            }
//                        }
//                    }
//                }
//            })
//
//            dataTask.resume()
//        }
//        if let imageUrl = self.orgData?.logoImageURL{
//            var headers = [
//                "Authorization": "Bearer \(UserInfo.currentUser()?.token ?? "")"
//            ]
//
//            if let tokendata = KeyChain.load(key: "iGrantioToken") {
//                                 let token = String(data: tokendata, encoding: .utf8) ?? ""
//                                 let hearDict = ["Authorization":"ApiKey \(token)"]
//                                 headers = hearDict
//                             }
//
//            let request = NSMutableURLRequest(url: imageUrl,
//                                              cachePolicy: .useProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.httpMethod = "GET"
//            request.allHTTPHeaderFields = headers
//
//            let session = URLSession.shared
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//                if (error != nil) {
//                    print(error!)
//                } else {
//                    if data != nil {
//                        if let image = UIImage.init(data: data!) {
//                            DispatchQueue.main.async {
//                                 self.logoImageView.image = image
//                            }
//                        }
//                    }
//                }
//            })
//
//            dataTask.resume()
//        }
        
    }

}
