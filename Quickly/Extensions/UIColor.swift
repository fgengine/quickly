//
//  Quickly
//

import UIKit

public extension UIColor {
    
    var isOpaque: Bool {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            if (1 - a) > CGFloat.leastNonzeroMagnitude {
                return false
            }
            return true
        }
    }

    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 24) & 0xff) / 255.0,
            green: CGFloat((hex >> 16) & 0xff) / 255.0,
            blue: CGFloat((hex >> 8) & 0xff) / 255.0,
            alpha: CGFloat(hex & 0xff) / 255.0
        )
    }

    convenience init(hex: UInt32, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: alpha
        )
    }

    convenience init?(hexString: String) {
        let characterSet = CharacterSet.alphanumerics.inverted
        let trimmingHexString = hexString.trimmingCharacters(in: characterSet)
        let scaner = Scanner.init(string: trimmingHexString)
        var hexValue: UInt32 = 0
        scaner.scanHexInt32(&hexValue)
        switch trimmingHexString.count {
        case 2:
            let v: CGFloat = CGFloat(hexValue & 0xff) / 255
            self.init(red: v, green: v, blue: v, alpha: 1)
        case 3:
            let r: CGFloat = CGFloat((hexValue >> 8) * 17) / 255
            let g: CGFloat = CGFloat(((hexValue >> 4) & 0xf) * 17) / 255
            let b: CGFloat = CGFloat((hexValue & 0xf) * 17) / 255
            self.init(red: r, green: g, blue: b, alpha: 1)
        case 6:
            let r: CGFloat = CGFloat((hexValue >> 16) & 0xff) / 255
            let g: CGFloat = CGFloat((hexValue >> 8) & 0xff) / 255
            let b: CGFloat = CGFloat(hexValue & 0xff) / 255
            self.init(red: r, green: g, blue: b, alpha: 1)
        case 8:
            let r: CGFloat = CGFloat((hexValue >> 24) & 0xff) / 255
            let g: CGFloat = CGFloat((hexValue >> 16) & 0xff) / 255
            let b: CGFloat = CGFloat((hexValue >> 8) & 0xff) / 255
            let a: CGFloat = CGFloat(hexValue & 0xff) / 255
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            return nil
        }
    }

    func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String.init(format: "#%02X%02X%02X%02X", Int(255 * r), Int(255 * g), Int(255 * b), Int(255 * a))
    }

    static func random() -> UIColor {
        return self.random(alpha: 1.0)
    }

    static func random(alpha: CGFloat) -> UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

    func lerp(_ to: UIColor, progress: CGFloat) -> UIColor {
        var selfR: CGFloat = 0, toR: CGFloat = 0
        var selfG: CGFloat = 0, toG: CGFloat = 0
        var selfB: CGFloat = 0, toB: CGFloat = 0
        var selfA: CGFloat = 0, toA: CGFloat = 0
        self.getRed(&selfR, green: &selfG, blue: &selfB, alpha: &selfA)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return UIColor(
            red: selfR.lerp(toR, progress: progress),
            green: selfG.lerp(toG, progress: progress),
            blue: selfB.lerp(toB, progress: progress),
            alpha: selfA.lerp(toA, progress: progress)
        )
    }

}
