//
//  Quickly
//

#if os(iOS)

    import UIKit

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

        public static func random() -> UIColor {
            return self.random(alpha: 1.0)
        }

        public func hexString() -> String? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) == true {
                return String.init(format: "#%02X%02X%02X%02X", Int(red * 255.0), Int(green * 255.0), Int(blue * 255.0), Int(alpha * 255.0))
            } else {
                return nil
            }
        }

        public static func random(alpha: CGFloat) -> UIColor {
            let randomRed: CGFloat = CGFloat(drand48())
            let randomGreen: CGFloat = CGFloat(drand48())
            let randomBlue: CGFloat = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        }

    }

#endif

