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
    var countryText: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.parentViewController = self
        //countryTextField.showCountryText = true
        
        phoneTextField.delegate = self
        
    }

    
}

extension ViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(textField: UITextField, name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print("please enter valid phone number")
        
    }

}
