//
//  Quickly
//

import UIKit

public protocol IQText {

    var attributed: NSAttributedString { get }

    func size() -> CGSize
    func size(width: CGFloat) -> CGSize
    func size(height: CGFloat) -> CGSize
    func size(size: CGSize) -> CGSize

}

extension IQText {

    public func size() -> CGSize {
        return self.size(size: CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        ))
    }

    public func size(width: CGFloat) -> CGSize {
        return self.size(size: CGSize(
            width: width,
            height: CGFloat.greatestFiniteMagnitude
        ))
    }

    public func size(height: CGFloat) -> CGSize {
        return self.size(size: CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: height
        ))
    }

    public func size(size: CGSize) -> CGSize {
        let rect: CGRect = self.attributed.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin],
            context: nil
        )
        return rect.integral.size
    }

}
