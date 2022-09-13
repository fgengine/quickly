//
//  Quickly
//

import UIKit

public protocol QLayoutTarget : AnyObject {
}

public struct QLayoutAxisX {
}

public struct QLayoutAxisY {
}

public struct QLayoutDimension {
}

public struct QLayoutItem< T > {

    public let item: Any
    public let attribute: NSLayoutConstraint.Attribute
    public let constant: CGFloat
    public let multiplier: CGFloat

    public init(
        _ item: Any,
        _ attribute: NSLayoutConstraint.Attribute,
        _ constant: CGFloat = 0,
        _ multiplier: CGFloat = 1
    ) {
        self.item = item
        self.attribute = attribute
        self.constant = constant
        self.multiplier = multiplier
    }
    
    public func multiplier(_ value: CGFloat) -> QLayoutItem< T > {
        return QLayoutItem(self.item, self.attribute, self.constant, value)
    }
    
    public func offset(_ value: CGFloat) -> QLayoutItem< T > {
        return QLayoutItem(self.item, self.attribute, value, self.multiplier)
    }

    fileprivate func _constrain(
        _ secondItem: QLayoutItem,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: self.item,
            attribute: self.attribute,
            relatedBy: relation,
            toItem: secondItem.item,
            attribute: secondItem.attribute,
            multiplier: secondItem.multiplier,
            constant: self.constant + secondItem.constant
        )
    }

    fileprivate func _constrain(
        _ constant: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: self.item,
            attribute: self.attribute,
            relatedBy: relation,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.constant + constant
        )
    }

}

public func == < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .equal)
}

public func == (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .equal)
}

public func >= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .greaterThanOrEqual)
}

public func >= (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .greaterThanOrEqual)
}

public func <= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .lessThanOrEqual)
}

public func <= (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs._constrain(rhs, relation: .lessThanOrEqual)
}

extension UIView : QLayoutTarget {

    public var topLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .top) }
    public var leftLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .left) }
    public var leadingLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .leading) }
    public var rightLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .right) }
    public var trailingLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .trailing) }
    public var bottomLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .bottom) }
    public var centerXLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .centerX) }
    public var centerYLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .centerY) }
    public var widthLayout: QLayoutItem< QLayoutDimension > { return QLayoutItem(self, .width) }
    public var heightLayout: QLayoutItem< QLayoutDimension > { return QLayoutItem(self, .height) }

}

@available(iOS 9.0, *)
extension UILayoutGuide : QLayoutTarget {
    
    public var topLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .top) }
    public var leftLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .left) }
    public var leadingLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .leading) }
    public var rightLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .right) }
    public var trailingLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .trailing) }
    public var bottomLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .bottom) }
    public var centerXLayout: QLayoutItem< QLayoutAxisX > { return QLayoutItem(self, .centerX) }
    public var centerYLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self, .centerY) }
    public var widthLayout: QLayoutItem< QLayoutDimension > { return QLayoutItem(self, .width) }
    public var heightLayout: QLayoutItem< QLayoutDimension > { return QLayoutItem(self, .height) }
    
}

public extension UIViewController {

    var topLayoutGuideTopLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self.topLayoutGuide, .top) }
    var topLayoutGuideBottomLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self.topLayoutGuide, .bottom) }
    var bottomLayoutGuideTopLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self.bottomLayoutGuide, .top) }
    var bottomLayoutGuideBottomLayout: QLayoutItem< QLayoutAxisY > { return QLayoutItem(self.bottomLayoutGuide, .bottom) }

}

precedencegroup QLayoutPriorityPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}

infix operator ~ : QLayoutPriorityPrecedence

public func ~ (lhs: NSLayoutConstraint, rhs: UILayoutPriority) -> NSLayoutConstraint {
    lhs.priority = rhs
    return lhs
}

