//
//  Quickly
//

import UIKit

open class QToolbarStyleSheet : IQStyleSheet {
    
    public var isTranslucent: Bool
    public var tintColor: UIColor
    public var contentTintColor: UIColor

    public init(
        isTranslucent: Bool,
        tintColor: UIColor,
        contentTintColor: UIColor
    ) {
        self.isTranslucent = isTranslucent
        self.tintColor = tintColor
        self.contentTintColor = contentTintColor
    }
    
    public init(_ styleSheet: QToolbarStyleSheet) {
        self.isTranslucent = styleSheet.isTranslucent
        self.tintColor = styleSheet.tintColor
        self.contentTintColor = styleSheet.contentTintColor
    }
    
}

public class QToolbar : UIToolbar {
    
    public init(
        styleSheet: QToolbarStyleSheet? = nil,
        items: [UIBarButtonItem] = []
    ) {
        super.init(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 50
            )
        )
        if let styleSheet = styleSheet {
            self.apply(styleSheet)
        }
        self.items = items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(_ styleSheet: QToolbarStyleSheet) {
        self.isTranslucent = styleSheet.isTranslucent
        self.barTintColor = styleSheet.tintColor
        self.tintColor = styleSheet.contentTintColor
        self.sizeToFit()
    }
    
}
