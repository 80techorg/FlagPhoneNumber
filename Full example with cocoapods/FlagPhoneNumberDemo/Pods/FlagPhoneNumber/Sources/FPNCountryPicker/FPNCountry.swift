import UIKit

public struct FPNCountry {
    public var code: FPNCountryCode
    public var name: String
    public var phoneCode: String
    var flag: UIImage?

    init(code: String, name: String, phoneCode: String) {
        self.name = name
        self.phoneCode = phoneCode
        self.code = FPNCountryCode(rawValue: code)!
        self.flag = emojiFlag(countryCode: self.code.rawValue).image()
    
    }
    
    func emojiFlag(countryCode: String?) -> String {
        var string = ""
        //var country = countryCode.uppercaseString
        for e in countryCode!.unicodeScalars {
            
            let unicode = UnicodeScalar(127397 + e.value)
            string += "\(unicode!)"
        }
        return string
    }
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
