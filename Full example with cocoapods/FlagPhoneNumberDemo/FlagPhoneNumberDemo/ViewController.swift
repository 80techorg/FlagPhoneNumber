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
    @IBOutlet weak var countryTextField: FCTextField!
    var countryText: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.showPhoneCode = true
        phoneTextField.parentViewController = self
//        phoneTextField.setFlag(for: FPNCountryCode.KW)
        countryTextField.showPhoneCode = false
        //countryTextField.showCountryText = true
        
        countryTextField.setFlag(for: FPNCountryCode.init(rawValue: "KW")!)
        countryTextField.showPhoneCode = false
        countryTextField.parentViewController = self
        countryTextField.delegate = self
        phoneTextField.delegate = self
        
    }

    
}

extension ViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(textField: UITextField, name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print("please enter valid phone number")
        
    }

//    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
//        print(name, dialCode, code)
//       // countryTextField.text = name
//    }
}
