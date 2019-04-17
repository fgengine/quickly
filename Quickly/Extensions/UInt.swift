//
//  Quickly
//

extension UInt {
    
    init?(_ string: String, radix: UInt) {
        var result = UInt(0)
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        for digit in string.lowercased() {
            if let index = digits.firstIndex(of: digit) {
                let val = UInt(digits.distance(from: digits.startIndex, to: index))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = result
    }
    
}
