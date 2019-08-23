//
//  PickerButton.swift
//  iGrant
//
//  Created by Mohamed Rebin on 21/01/19.
//  Copyright © 2019 iGrant.com. All rights reserved.
//

import UIKit

class PickerButton: UIButton {
 
        
        var dateView = UIView()
        var toolBarView = UIView()
        
        override var inputView: UIView {
            
            get {
                return self.dateView
            }
            set {
                self.dateView = newValue
                self.becomeFirstResponder()
            }
            
        }
        
        override var inputAccessoryView: UIView {
            get {
                return self.toolBarView
            }
            set {
                self.toolBarView = newValue
            }
        }
        
        override var canBecomeFirstResponder: Bool {
            return true
        }
        

}
