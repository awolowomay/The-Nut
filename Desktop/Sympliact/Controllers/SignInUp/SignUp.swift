//
//  SignUp.swift
//  MedProj
//
//  Created by Michael McKenna on 1/23/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit
import Material

class SignUp: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var emailField: TextField!
    @IBOutlet var passwordField: TextField!
    @IBOutlet var confirmPasswordField: TextField!
 
    
    @IBAction func signUpAction(_ sender: Any) {
        
    }
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.placeholderNormalColor = UIColor.white
        emailField.placeholderActiveColor = UIColor.white
        emailField.dividerNormalColor = UIColor.white
        emailField.dividerActiveColor = UIColor.white
        emailField.isClearIconButtonEnabled = true
        
        passwordField.placeholderNormalColor = UIColor.white
        passwordField.placeholderActiveColor = UIColor.white
        passwordField.dividerNormalColor = UIColor.white
        passwordField.dividerActiveColor = UIColor.white
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.visibilityIconButton?.tintColor = UIColor.white
       
        confirmPasswordField.placeholderNormalColor = UIColor.white
        confirmPasswordField.placeholderActiveColor = UIColor.white
        confirmPasswordField.dividerNormalColor = UIColor.white
        confirmPasswordField.dividerActiveColor = UIColor.white
        confirmPasswordField.isVisibilityIconButtonEnabled = true
        confirmPasswordField.visibilityIconButton?.tintColor = UIColor.white
        
        
        
        
        
        

        let dismissKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUp.dismissKeyboard))
        scrollView.addGestureRecognizer(dismissKeyboardTap)
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }

    // MARK: - Text field methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === emailField) {
          let _ = passwordField.becomeFirstResponder()
        } else if (textField === passwordField) {
          let _ = confirmPasswordField.becomeFirstResponder()
        } else {
          confirmPasswordField.resignFirstResponder()
        }
        //performSegue(withIdentifier: "setupSegue", sender: nil)

        return true
    }
    
    // MARK: - Keyboard methods
    
    //closes keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        // Scroll text field above keyboard
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height+100, 0.0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height+100
            if let activeFieldPresent = activeField {
                if (!aRect.contains(activeFieldPresent.frame.origin)) {
                    self.scrollView.scrollRectToVisible(activeFieldPresent.frame, animated: true)
                    self.scrollView.isScrollEnabled = false
                }
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        // Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize.height-100, 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.view.endEditing(true)
            self.scrollView.isScrollEnabled = false
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        scrollView.endEditing(true)
    }

    

}
