//
//  Quickly
//

public extension UIColor {

    public convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 24) & 0xff) / 255.0,
            green: CGFloat((hex >> 16) & 0xff) / 255.0,
            blue: CGFloat((hex >> 8) & 0xff) / 255.0,
            alpha: CGFloat(hex & 0xff) / 255.0
        )
    }

    public convenience init(hex: UInt32, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: alpha
        )
    }

    public convenience init?(hexString: String) {
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

    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String.init(format: "#%02X%02X%02X%02X", Int(255 * r), Int(255 * g), Int(255 * b), Int(255 * a))
    }

    public static func random() -> UIColor {
        return self.random(alpha: 1.0)
    }

    public static func random(alpha: CGFloat) -> UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

    public func lerp(_ to: UIColor, progress: CGFloat) -> UIColor {
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
