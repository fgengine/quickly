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

public struct QQLayoutAxisX {
}

public struct QQLayoutAxisY {
}

public struct QQLayoutDimension {
}

public struct QLayoutItem< T > {

    public let item: AnyObject
    public let attribute: NSLayoutAttribute
    public let constant: CGFloat
    public let multiplier: CGFloat

    public init(
        _ item: AnyObject,
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

public func == (lhs: QLayoutItem< QQLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .equal)
}

public func >= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func >= (lhs: QLayoutItem< QQLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

public func <= < T > (lhs: QLayoutItem< T >, rhs: QLayoutItem< T >) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

public func <= (lhs: QLayoutItem< QQLayoutDimension >, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .lessThanOrEqual)
}

public extension QLayoutTarget {

    public var leftLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .left)
    }

    public var rightLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .right)
    }

    public var topLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .top)
    }

    public var bottomLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .bottom)
    }

    public var leadingLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .leading)
    }

    public var trailingLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .trailing)
    }

    public var widthLayout: QLayoutItem< QQLayoutDimension > {
        return QLayoutItem(self, .width)
    }

    public var heightLayout: QLayoutItem< QQLayoutDimension > {
        return QLayoutItem(self, .height)
    }

    public var centerXLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .centerX)
    }

    public var centerYLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .centerY)
    }

}

public extension UIView {

    public var firstBaselineLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .firstBaseline)
    }

    public var lastBaselineLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .lastBaseline)
    }

    public var leftMarginLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .leftMargin)
    }

    public var rightMarginLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .rightMargin)
    }

    public var topMarginLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .topMargin)
    }

    public var bottomMarginLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .bottomMargin)
    }

    public var leadingMarginLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .leadingMargin)
    }

    public var trailingMarginLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .trailingMargin)
    }

    public var centerXMarginLayout: QLayoutItem< QQLayoutAxisX > {
        return QLayoutItem(self, .centerXWithinMargins)
    }

    public var centerYMarginLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(self, .centerYWithinMargins)
    }

}

public extension UIViewController {

    public var topLayoutGuideTopLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(topLayoutGuide, .top)
    }

    public var topLayoutGuideBottomLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(topLayoutGuide, .bottom)
    }

    public var bottomLayoutGuideTopLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(bottomLayoutGuide, .top)
    }

    public var bottomLayoutGuideBottomLayout: QLayoutItem< QQLayoutAxisY > {
        return QLayoutItem(bottomLayoutGuide, .bottom)
    }

}

precedencegroup QLayoutPriorityPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}

infix operator ~ : QLayoutPriorityPrecedence

public func ~ (lhs: NSLayoutConstraint, rhs: UILayoutPriority) -> NSLayoutConstraint {
    let constraint: NSLayoutConstraint = NSLayoutConstraint(
        item: lhs.firstItem,
        attribute: lhs.firstAttribute,
        relatedBy: lhs.relation,
        toItem: lhs.secondItem,
        attribute: lhs.secondAttribute,
        multiplier: lhs.multiplier,
        constant: lhs.constant
    )
    constraint.priority = rhs
    return constraint
}
