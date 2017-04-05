//
//  Extensions.swift
//  MedProj
//
//  Created by Michael McKenna on 2/7/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIView {
    
    func makeRound(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0.5 * self.frame.size.width
    }
    
    func addDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
    }
    
    /**
        Parameters: Which corners to be rounded and to what degree
        Example: view.roundCorners(.TopRight, 5)
     */
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = false
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = Colors.greenWithAlpha.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension Object {
    func generateClientId() -> Int {
        if var negativeInt = UserDefaults.standard.value(forKey: "clientId") as? Int {
            negativeInt -= 1
            UserDefaults.standard.setValue(negativeInt, forKey: "clientId")
            return negativeInt
        } else {
            UserDefaults.standard.setValue(-1, forKey: "clientId")
            return -1
        }
    }
}

extension UIColor {
    static func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UISearchController {
    func setUp() {
        self.searchBar.sizeToFit()
        self.searchBar.barTintColor = Colors.greenWithAlpha
        self.searchBar.backgroundColor = Colors.greenWithAlpha
        self.searchBar.tintColor = Colors.greenWithAlpha
        self.dimsBackgroundDuringPresentation = false // default is YES

        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.textColor = Colors.greenWithAlpha
        let glassIconView = textFieldInsideSearchBar.leftView as! UIImageView
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = Colors.greenWithAlpha
        
        //Magnifying glass
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = Colors.greenWithAlpha
    }
}
