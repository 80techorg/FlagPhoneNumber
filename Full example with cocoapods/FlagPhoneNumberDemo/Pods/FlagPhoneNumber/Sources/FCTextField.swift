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
    @objc public var flagSize: CGSize = CGSize(width: 32, height: 32) {
        didSet {
            layoutSubviews()
        }
    }
    
    /// The edges insets of the flag button
    @objc public var flagButtonEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) {
        didSet {
            layoutSubviews()
        }
    }
    
    /// The size of the leftView
    private var leftViewSizewithoutCode: CGSize {
        let width = flagSize.width + flagButtonEdgeInsets.left + flagButtonEdgeInsets.right
        let height = bounds.height
        
        return CGSize(width: width, height: height)
    }
    
    
    private lazy var countryPicker: FPNCountryPicker = FPNCountryPicker()
    //private var toolbar: UIToolbar = UIToolbar()
    
    public var flagButton: UIButton = UIButton()
    // private var countryButton: UIButton = UIButton()
    
    
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        flagButton.imageEdgeInsets = flagButtonEdgeInsets
        addTarget(self, action: #selector(didEditText), for: .editingChanged)
    }
    
    private func setup() {
        setupFlagButton()
        setupLeftView()
        displayCountryKeyboardFromButton()
        addTarget(self, action: #selector(displayCountryKeyboardFromButton), for: .touchDown)
        setupCountryPicker()
    }
    
    func setupFlagImage() {
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
    }
    
    private func setupLeftView() {
        
        let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewSizewithoutCode.width, height: leftViewSizewithoutCode.height))
        wrapperView.addSubview(flagButton)
        
        let views = ["flag": flagButton]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[flag]|", options: [], metrics: nil, views: views)
        
        wrapperView.addConstraints(horizontalConstraints)
        
        for key in views.keys {
            wrapperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(key)]|", options: [], metrics: nil, views: views))
        }
        
        leftView = wrapperView
        leftViewMode = .always
        
        
    }
    
    
    
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
