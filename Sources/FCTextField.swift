//
//  FCTextField.swift
//  FlagPhoneNumber
//
//  Created by Mohamed El-Said on 8/25/19.
//


import UIKit


open class FCTextField: UITextField, FPNCountryPickerDelegate, FPNDelegate {
    
    override open var isHighlighted: Bool {
        didSet {
            // clear background color when selected
            self.layer.backgroundColor = .none
        }
    }
    
    /// The size of the flag
    @objc public var flagButtonSize: CGSize = CGSize(width: 50, height: 50) {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private var flagWidthConstraint: NSLayoutConstraint?
    private var flagHeightConstraint: NSLayoutConstraint?
 
    /// The size of the leftView
    private var leftViewSize: CGSize {
        let width = flagButtonSize.width
        let height = bounds.height

        return CGSize(width: width, height: height)
    }
    
    private lazy var countryPicker: FPNCountryPicker = FPNCountryPicker()
    
    public var flagButton: UIButton = UIButton()
    
    
    open  var showPhoneCode: Bool = true {
        didSet {
            countryPicker.showPhoneNumbers = showPhoneCode
            setup()
        }
    }
    
    
    
    open var selectedCountry: FPNCountry? {
        didSet {
            updateUI()
            
        }
    }
    
    /// If set, a search button appears in the picker inputAccessoryView to present a country search view controller
    @IBOutlet public var parentViewController: UIViewController?
    
    
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        parentViewController = nil
    }
    
    private func setup() {
        setupFlagButton()
        setupLeftView()
        addTarget(self, action: #selector(displayCountryKeyboardFromButton), for: .touchDown)
        setupCountryPicker()
    }
    
    func setupFlagImage() {
        //flagImage.con
    }
    
    private func setupFlagButton() {
        flagButton.contentHorizontalAlignment = .fill
        flagButton.contentVerticalAlignment = .fill
        flagButton.imageView?.contentMode = .scaleAspectFit
        //flagButton.isHighlighted = false
        flagButton.addTarget(self, action: #selector(displayCountryKeyboardFromButton), for: .touchUpInside)
        flagButton.accessibilityLabel = "flagButton"
        flagButton.tintAdjustmentMode = .normal
        //flagButton.isSelected = false
        flagButton.isUserInteractionEnabled = false
        flagButton.translatesAutoresizingMaskIntoConstraints = false
        flagButton.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    private func setupLeftView() {
        
        leftView = UIView()
        leftViewMode = .always
       

        leftView?.addSubview(flagButton)
        //leftView?.addSubview(phoneCodeTextField)


        flagWidthConstraint = NSLayoutConstraint(item: flagButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: flagButtonSize.width)
        flagHeightConstraint = NSLayoutConstraint(item: flagButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: flagButtonSize.height)

        flagWidthConstraint?.isActive = true
        flagHeightConstraint?.isActive = true

        NSLayoutConstraint(item: flagButton, attribute: .centerY, relatedBy: .equal, toItem: leftView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: flagButton, attribute: .leading, relatedBy: .equal, toItem: leftView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: flagButton, attribute: .leading, relatedBy: .equal, toItem: flagButton, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: flagButton, attribute: .trailing, relatedBy: .equal, toItem: leftView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: flagButton, attribute: .top, relatedBy: .equal, toItem: leftView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: flagButton, attribute: .bottom, relatedBy: .equal, toItem: leftView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
    }
    
    open override func updateConstraints() {
        super.updateConstraints()

       // flagButton.imageEdgeInsets = flagButtonEdgeInsets
        flagWidthConstraint?.constant = flagButtonSize.width
        flagHeightConstraint?.constant = flagButtonSize.height
    }
    
//    private func updateLeftView() {
//        let leftViewFrame: CGRect = leftView?.frame ?? .zero
//        let width: CGFloat = min(bounds.size.width, leftViewSize.width)
//        let height: CGFloat = min(bounds.size.height, leftViewSize.height)
//        let newRect: CGRect = CGRect(x: leftViewFrame.minX, y: leftViewFrame.minY, width: width, height: height)
//
//        leftView?.frame = newRect
//
//    }
    
    private func setupCountryPicker() {
        countryPicker.countryPickerDelegate = self
        countryPicker.backgroundColor = .white
        
        if let regionCode = Locale.current.regionCode, let countryCode = FPNCountryCode(rawValue: regionCode) {
            countryPicker.setCountry(countryCode)
        } else if let firstCountry = countryPicker.countries.first {
            countryPicker.setCountry(firstCountry.code)
        }
    }
    
    
    @objc private func displayCountryKeyboardFromButton() {
        self.inputView = countryPicker
        self.inputAccessoryView = getToolBarFromButton(with: getCountryListBarButtonItems())
        self.tintColor = .clear
        self.reloadInputViews()
        // self.becomeFirstResponder()
    }
    
    @objc private func displayAlphabeticKeyBoard() {
        countryPicker.removeFromSuperview()
        resetKeyBoard()
        showSearchController()
    }
    
    @objc private func resetKeyBoard() {
        inputView = countryPicker
        //inputAccessoryView = getToolBarFromButton(with: getCountryListBarButtonItems())
        if parentViewController != nil {
            parentViewController?.view.endEditing(true)
        }
        resignFirstResponder()
    }
    
    
    // - Public
    
    /// Set the country image according to country code. Example "FR"
    public func setFlag(for countryCode: FPNCountryCode) {
        countryPicker.setCountry(countryCode)
    }
    
    
    /// Set the country list excluding the provided countries
    public func setCountries(excluding countries: [FPNCountryCode]) {
        countryPicker.setup(without: countries)
    }
    
    /// Set the country list including the provided countries
    public func setCountries(including countries: [FPNCountryCode]) {
        countryPicker.setup(with: countries)
    }
    
    /// Set the country image according to country code. Example "FR"
    @objc public func setFlag(for key: FPNOBJCCountryKey) {
        if let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {
            countryPicker.setCountry(countryCode)
        }
    }
    
    /// Set the country list excluding the provided countries
    @objc public func setCountries(excluding countries: [Int]) {
        let countryCodes: [FPNCountryCode] = countries.compactMap({ index in
            if let key = FPNOBJCCountryKey(rawValue: index), let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {
                return countryCode
            }
            return nil
        })
        
        countryPicker.setup(without: countryCodes)
    }
    
    /// Set the country list including the provided countries
    @objc public func setCountries(including countries: [Int]) {
        let countryCodes: [FPNCountryCode] = countries.compactMap({ index in
            if let key = FPNOBJCCountryKey(rawValue: index), let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {
                return countryCode
            }
            return nil
        })
        
        countryPicker.setup(with: countryCodes)
    }
    
    // Private
    
    @objc private func didEditText() {
        flagButton.setImage(selectedCountry?.flag, for: .normal)
        text = selectedCountry?.name
    }
    
    
    
    private func updateUI() {
        
        didEditText()
    }
    
    private func showSearchController() {
        if let countries = countryPicker.countries {
            let searchCountryViewController = FPNSearchCountryViewController(countries: countries, showPhoneCode: showPhoneCode)
            let navigationViewController = UINavigationController(rootViewController: searchCountryViewController)
            
            searchCountryViewController.delegate = self
            
            
            parentViewController?.present(navigationViewController, animated: true, completion: nil)
        }
    }
    
    private func getToolBarFromButton(with items: [UIBarButtonItem]) -> UIToolbar {
        
        let textToolbar: UIToolbar = UIToolbar()
        
        textToolbar.barStyle = UIBarStyle.default
        textToolbar.items = items
        textToolbar.sizeToFit()
        
        return textToolbar
    }
    
    private func getCountryListBarButtonItems() -> [UIBarButtonItem] {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resetKeyBoard))
        
        doneButton.accessibilityLabel = "doneButton"
        
        if parentViewController != nil {
            let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displayAlphabeticKeyBoard))
            
            searchButton.accessibilityLabel = "searchButton"
            
            
            return [searchButton, space, doneButton]
        }
        
        return [space, doneButton]
    }
    
    
    // - FPNCountryPickerDelegate
    
    func countryPhoneCodePicker(_ picker: FPNCountryPicker, didSelectCountry country: FPNCountry) {
        (delegate as? FPNTextFieldDelegate)?.fpnDidSelectCountry(textField: self, name: country.name, dialCode: country.phoneCode, code: country.code.rawValue)
        selectedCountry = country
        
    }
    
    // - FPNDelegate
    
    internal func fpnDidSelect(country: FPNCountry) {
        setFlag(for: country.code)
        
    }
}
