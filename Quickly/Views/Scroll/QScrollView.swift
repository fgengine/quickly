//
//  Quickly
//

import UIKit

open class QScrollView : UIScrollView, IQView {
    
    public var direction: Direction {
        didSet { self.setNeedsUpdateConstraints() }
    }

    public private(set) var contentView: UIView!

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }
    private var _contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._contentConstraints) }
        didSet { self.contentView.addConstraints(self._contentConstraints) }
    }
    
    public required init() {
        self.direction = .vertical
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.setup()
    }

    public init(frame: CGRect, direction: Direction) {
        self.direction = direction
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        self.direction = .vertical
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
        self.backgroundColor = UIColor.clear

        self.contentView = UIView(frame: self.bounds)
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.contentView)
    }

    open override func updateConstraints() {
        super.updateConstraints()
        
        self._constraints = [
            self.topLayout == self.contentView.topLayout,
            self.leadingLayout == self.contentView.leadingLayout,
            self.trailingLayout == self.contentView.trailingLayout,
            self.bottomLayout == self.contentView.bottomLayout
        ]

        var contentConstraints: [NSLayoutConstraint] = []
        switch self.direction {
        case .stretch:
            contentConstraints.append(self.widthLayout == self.contentView.widthLayout)
            contentConstraints.append(self.heightLayout == self.contentView.heightLayout)
        case .vertical:
            contentConstraints.append(self.widthLayout == self.contentView.widthLayout)
        case .horizontal:
            contentConstraints.append(self.heightLayout == self.contentView.heightLayout)
        }
        self._contentConstraints = contentConstraints
    }

}

extension QScrollView {
    
    public enum Direction {
        case vertical
        case horizontal
        case stretch
    }
    
}
