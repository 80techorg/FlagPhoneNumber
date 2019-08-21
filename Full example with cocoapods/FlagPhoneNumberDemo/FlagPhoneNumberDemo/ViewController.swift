//
//  ViewController.swift
//  FlagPhoneNumberDemo
//
//  Created by Mohamed El-Said on 8/20/19.
//  Copyright © 2019 Mohamed El-Said. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class ViewController: UIViewController {

    @IBOutlet weak var phoneTextField: FPNTextField!
    @IBOutlet weak var countryTextField: FPNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.showPhoneCode = true
        phoneTextField.parentViewController = self
        
        countryTextField.showPhoneCode = false
        countryTextField.parentViewController = self
        countryTextField.delegate = self
        phoneTextField.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }

    
}

extension ViewController: FPNTextFieldDelegate {
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print("please enter valid phone number")
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
         countryTextField.text = name
    }
}
