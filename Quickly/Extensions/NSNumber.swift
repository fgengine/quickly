//
//  Quickly
//

public extension NSNumber {

    public class func number(from string: String) -> NSNumber? {
        let formatter = NumberFormatter()
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
        return number
    }

}
