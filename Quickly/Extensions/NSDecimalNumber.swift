//
//  Quickly
//

import Foundation

public extension NSDecimalNumber {

    class func decimalNumber(from string: String) -> NSDecimalNumber? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.locale = Locale.current;
        formatter.formatterBehavior = .behavior10_4;
        formatter.numberStyle = .none;

        var number = formatter.number(from: string)
        if number == nil {
            if formatter.decimalSeparator == "." {
                formatter.decimalSeparator = ","
            } else {
                formatter.decimalSeparator = "."
            }
            number = formatter.number(from: string)
        }
        return number as? NSDecimalNumber
    }
    
    class func decimalNumber(from string: Substring) -> NSDecimalNumber? {
        return self.decimalNumber(from: String(string))
    }

}
