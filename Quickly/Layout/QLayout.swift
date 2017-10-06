//
//  Quickly
//


import UIKit

public protocol QLayoutTarget: AnyObject {
}

extension UIView: QLayoutTarget {
}

@available(iOS 9.0, *)
extension UILayoutGuide: QLayoutTarget {
}

public struct QLayoutAxisX {
}

public struct QLayoutAxisY {
}

public struct QLayoutDimension {
}

public struct QLayoutItem< T > {

    public let item: Any
    public let attribute: NSLayoutAttribute
    public let constant: CGFloat
    public let multiplier: CGFloat

    public init(
        _ item: Any,
        _ attribute: NSLayoutAttribute,
        _ constant: CGFloat = 0,
        _ multiplier: CGFloat = 1
    ) {
        self.item = item
        self.attribute = attribute
        self.constant = constant
        self.multiplier = multiplier
    }

    fileprivate func constrain(
        _ secondItem: QLayoutItem,
        relation: NSLayoutRelation
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

    fileprivate func constrain(
        _ constant: CGFloat,
        relation: NSLayoutRelation
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

    fileprivate func item(multiplier: CGFloat) -> QLayoutItem {
        return QLayoutItem(self.item, self.attribute, self.constant, multiplier)
    }

    fileprivate func item(constant: CGFloat) -> QLayoutItem {
        return QLayoutItem(self.item, self.attribute, constant, self.multiplier)
    }

}

public func * < T > (lhs: QLayoutItem< T >, rhs: CGFloat) -> QLayoutItem< T > {
    return lhs.item(multiplier: lhs.multiplier * rhs)
}

public func / < T > (lhs: QLayoutItem< T >, rhs: CGFloat) -> QLayoutItem< T > {
    return lhs.item(multiplier: lhs.multiplier / rhs)
}

public func + < T > (lhs: QLayoutItem< T >, rhs: CGFloat) -> QLayoutItem< T > {
    return lhs.item(constant: lhs.constant + rhs)
}

public func - < T > (lhs: QLayoutItem< T >, rhs: CGFloat) -> QLayoutItem< T > {
    return lhs.item(constant: lhs.constant - rhs)
}

public func == < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .equal)
}

public func == (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .equal)
}

public func >= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func >= (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func <= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

public func <= (lhs: QLayoutItem< QLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

public extension QLayoutTarget {

    public var leftLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .left)
    }

    public var rightLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .right)
    }

    public var topLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .top)
    }

    public var bottomLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .bottom)
    }

    public var leadingLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .leading)
    }

    public var trailingLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .trailing)
    }

    public var widthLayout: QLayoutItem< QLayoutDimension > {
        return QLayoutItem(self, .width)
    }

    public var heightLayout: QLayoutItem< QLayoutDimension > {
        return QLayoutItem(self, .height)
    }

    public var centerXLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .centerX)
    }

    public var centerYLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .centerY)
    }

}

public extension UIView {

    public var firstBaselineLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .firstBaseline)
    }

    public var lastBaselineLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .lastBaseline)
    }

    public var leftMarginLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .leftMargin)
    }

    public var rightMarginLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .rightMargin)
    }

    public var topMarginLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .topMargin)
    }

    public var bottomMarginLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .bottomMargin)
    }

    public var leadingMarginLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .leadingMargin)
    }

    public var trailingMarginLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .trailingMargin)
    }

    public var centerXMarginLayout: QLayoutItem< QLayoutAxisX > {
        return QLayoutItem(self, .centerXWithinMargins)
    }

    public var centerYMarginLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self, .centerYWithinMargins)
    }

}

public extension UIViewController {

    public var topLayoutGuideTopLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self.topLayoutGuide, .top)
    }

    public var topLayoutGuideBottomLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self.topLayoutGuide, .bottom)
    }

    public var bottomLayoutGuideTopLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self.bottomLayoutGuide, .top)
    }

    public var bottomLayoutGuideBottomLayout: QLayoutItem< QLayoutAxisY > {
        return QLayoutItem(self.bottomLayoutGuide, .bottom)
    }

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

