//
//  Quickly
//

import Quickly.Private

public extension QPlatformColor {

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
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        var a: CGFloat = 1
        guard QJsonImplColorComponentsFromString(hexString, &r, &g, &b, &a) else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    public func hexString() -> String? {
        return QJsonImplStringFromColor(self)
    }

    public static func random() -> QPlatformColor {
        return self.random(alpha: 1.0)
    }

    public static func random(alpha: CGFloat) -> QPlatformColor {
        let r: CGFloat = CGFloat(drand48())
        let g: CGFloat = CGFloat(drand48())
        let b: CGFloat = CGFloat(drand48())
        return QPlatformColor(red: r, green: g, blue: b, alpha: alpha)
    }

    public func lerp(_ to: QPlatformColor, progress: CGFloat) -> QPlatformColor {
        var selfR: CGFloat = 0, toR: CGFloat = 0
        var selfG: CGFloat = 0, toG: CGFloat = 0
        var selfB: CGFloat = 0, toB: CGFloat = 0
        var selfA: CGFloat = 0, toA: CGFloat = 0
        self.getRed(&selfR, green: &selfG, blue: &selfB, alpha: &selfA)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        return QPlatformColor(
            red: selfR.lerp(toR, progress: progress),
            green: selfG.lerp(toG, progress: progress),
            blue: selfB.lerp(toB, progress: progress),
            alpha: selfA.lerp(toA, progress: progress)
        )
    }

}
