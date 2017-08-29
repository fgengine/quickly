//
//  Quickly
//

import UIKit

public enum QButtonImagePosition: Int {
    case top
    case left
    case right
    case bottom
}

@IBDesignable
open class QButton: QControl {

    open override var isHighlighted: Bool {
        didSet { self.applyStyle() }
    }
    open override var isSelected: Bool {
        didSet { self.applyStyle() }
    }
    open override var isEnabled: Bool {
        didSet { self.applyStyle() }
    }
    open override var contentHorizontalAlignment: UIControlContentHorizontalAlignment {
        didSet { self.setNeedsUpdateConstraints() }
    }
    open override var contentVerticalAlignment: UIControlContentVerticalAlignment {
        didSet { self.setNeedsUpdateConstraints() }
    }
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var imagePosition: QButtonImagePosition = .left {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var imageInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var normalStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var highlightedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var disabledStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedHighlightedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedDisabledStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public private(set) var contentView: QView!
    public private(set) var imageView: QImageView!
    public private(set) var textLabel: QLabel!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.currentConstraints) }
        didSet { self.addConstraints(self.currentConstraints) }
    }
    internal var contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.contentConstraints) }
        didSet { self.contentView.addConstraints(self.contentConstraints) }
    }

    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear

        self.contentView = QView(frame: self.bounds)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.isUserInteractionEnabled = false
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)

        self.imageView = QImageView(frame: self.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.isUserInteractionEnabled = false
        self.imageView.isHidden = true
        self.contentView.addSubview(self.imageView)

        self.textLabel = QLabel(frame: self.bounds)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.isUserInteractionEnabled = false
        self.textLabel.isHidden = true
        self.contentView.addSubview(self.textLabel)
    }

    open override var intrinsicContentSize: CGSize {
        get {
            return self.sizeThatFits(CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            ))
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize: CGSize = CGSize(
            width: size.width - (self.contentInsets.left + self.contentInsets.right),
            height: size.height - (self.contentInsets.top + self.contentInsets.bottom)
        )
        var imageSize: CGSize
        if self.imageView.isHidden == false {
            let imageSizeThatFits: CGSize = self.imageView.sizeThatFits(contentSize)
            imageSize = CGSize(
                width: self.imageInsets.left + imageSizeThatFits.width + self.imageInsets.right,
                height: self.imageInsets.top + imageSizeThatFits.height + self.imageInsets.bottom
            )
        } else {
            imageSize = CGSize.zero
        }
        var textSize: CGSize
        if self.textLabel.isHidden == false {
            let textSizeThatFits: CGSize = self.textLabel.sizeThatFits(contentSize)
            textSize = CGSize(
                width: self.textInsets.left + textSizeThatFits.width + self.textInsets.right,
                height: self.textInsets.top + textSizeThatFits.height + self.textInsets.bottom
            )
        } else {
            textSize = CGSize.zero
        }
        switch self.imagePosition {
        case .top, .bottom:
            return CGSize(
                width: self.contentInsets.left + max(imageSize.width, textSize.width) + self.contentInsets.right,
                height: self.contentInsets.top + imageSize.height + textSize.height + self.contentInsets.bottom
            )
        case .left, .right:
            return CGSize(
                width: self.contentInsets.left + imageSize.width + textSize.width + self.contentInsets.right,
                height: self.contentInsets.top + max(imageSize.height, textSize.height) + self.contentInsets.bottom
            )
        }
    }

    open override func sizeToFit() {
        super.sizeToFit()

        self.frame.size = self.sizeThatFits(CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        ))
    }

    public func currentStyle() -> QButtonStyle? {
        if self.isEnabled == false {
            if self.isSelected == true {
                return self.selectedDisabledStyle
            } else {
                return self.disabledStyle
            }
        } else if self.isHighlighted == true {
            if self.isSelected == true {
                return self.selectedHighlightedStyle
            } else {
                return self.highlightedStyle
            }
        } else if self.isSelected == true {
            return self.selectedStyle
        }
        return self.normalStyle
    }

    public func applyStyle() {
        if let style: QButtonStyle = self.currentStyle() {
            self.applyStyle(style)
            self.invalidateIntrinsicContentSize()
        }
    }

    public func applyStyle(_ style: QButtonStyle) {
        if let color: UIColor = style.color {
            self.backgroundColor = color
        }
        if let borderColor: UIColor = style.borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth: CGFloat = style.borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let cornerRadius: CGFloat = style.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let imageSource: QImageSource = style.imageSource {
            self.imageView.source = imageSource
            self.imageView.isHidden = false

            if let imageTintColor: UIColor = style.imageTintColor {
                self.imageView.tintColor = imageTintColor
            }
        } else {
            self.imageView.isHidden = true
        }
        if let text: IQText = style.text {
            self.textLabel.text = text
            self.textLabel.isHidden = false
        } else {
            self.textLabel.isHidden = true
        }
    }

    open override func updateConstraints() {
        var currentConstraints: [NSLayoutConstraint] = []
        switch self.contentHorizontalAlignment {
        case .fill:
            currentConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
            break
        case .left:
            currentConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
            break
        case .center:
            currentConstraints.append(self.contentView.centerXLayout == self.centerXLayout)
            currentConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
            break
        case .right:
            currentConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
            break
        }
        switch self.contentVerticalAlignment {
        case .fill:
            currentConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
            break
        case .top:
            currentConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
            break
        case .center:
            currentConstraints.append(self.contentView.centerYLayout == self.centerYLayout)
            currentConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
            break
        case .bottom:
            currentConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
            break
        }
        self.currentConstraints = currentConstraints

        let existImage: Bool = self.imageView.isHidden == false
        let existText: Bool = self.textLabel.isHidden == false
        var contentConstraints: [NSLayoutConstraint] = []
        if (existImage == true) && (existText == true) {
            switch self.imagePosition {
            case .top:
                contentConstraints.append(self.imageView.topLayout == self.contentView.topLayout + self.imageInsets.top)
                contentConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + self.imageInsets.left)
                contentConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - self.imageInsets.right)
                contentConstraints.append(self.imageView.bottomLayout == self.textLabel.topLayout + (self.imageInsets.bottom + self.textInsets.top))
                contentConstraints.append(self.textLabel.leadingLayout == self.contentView.leadingLayout + self.textInsets.left)
                contentConstraints.append(self.textLabel.trailingLayout == self.contentView.trailingLayout - self.textInsets.right)
                contentConstraints.append(self.textLabel.bottomLayout == self.contentView.bottomLayout - self.textInsets.bottom)
                break
            case .left:
                contentConstraints.append(self.imageView.topLayout == self.contentView.topLayout + self.imageInsets.top)
                contentConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + self.imageInsets.left)
                contentConstraints.append(self.imageView.trailingLayout == self.textLabel.leadingLayout + (self.imageInsets.right + self.textInsets.left))
                contentConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout + self.imageInsets.bottom)
                contentConstraints.append(self.textLabel.topLayout == self.contentView.topLayout + self.textInsets.top)
                contentConstraints.append(self.textLabel.trailingLayout == self.contentView.trailingLayout - self.textInsets.right)
                contentConstraints.append(self.textLabel.bottomLayout == self.contentView.bottomLayout - self.textInsets.bottom)
                break
            case .right:
                contentConstraints.append(self.textLabel.topLayout == self.contentView.topLayout + self.textInsets.top)
                contentConstraints.append(self.textLabel.leadingLayout == self.contentView.leadingLayout + self.textInsets.left)
                contentConstraints.append(self.textLabel.trailingLayout == self.imageView.leadingLayout + (self.textInsets.right + self.imageInsets.left))
                contentConstraints.append(self.textLabel.bottomLayout == self.contentView.bottomLayout - self.textInsets.bottom)
                contentConstraints.append(self.imageView.topLayout == self.contentView.topLayout + self.imageInsets.top)
                contentConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - self.imageInsets.right)
                contentConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout + self.imageInsets.bottom)
                break
            case .bottom:
                contentConstraints.append(self.textLabel.topLayout == self.contentView.topLayout + self.textInsets.top)
                contentConstraints.append(self.textLabel.leadingLayout == self.contentView.leadingLayout + self.textInsets.left)
                contentConstraints.append(self.textLabel.trailingLayout == self.contentView.trailingLayout - self.textInsets.right)
                contentConstraints.append(self.textLabel.bottomLayout == self.imageView.topLayout + (self.imageInsets.top + self.textInsets.bottom))
                contentConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + self.imageInsets.left)
                contentConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - self.imageInsets.right)
                contentConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - self.imageInsets.bottom)
                break
            }
        } else if (existImage == true) || (existText == true) {
            contentConstraints.append(self.imageView.topLayout == self.contentView.topLayout + self.imageInsets.top)
            contentConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + self.imageInsets.left)
            contentConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - self.imageInsets.right)
            contentConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - self.imageInsets.bottom)
            contentConstraints.append(self.textLabel.topLayout == self.contentView.topLayout + self.textInsets.top)
            contentConstraints.append(self.textLabel.leadingLayout == self.contentView.leadingLayout + self.textInsets.left)
            contentConstraints.append(self.textLabel.trailingLayout == self.contentView.trailingLayout - self.textInsets.right)
            contentConstraints.append(self.textLabel.bottomLayout == self.contentView.bottomLayout - self.textInsets.bottom)
        } else {
            contentConstraints.append(self.contentView.widthLayout == 0)
            contentConstraints.append(self.contentView.heightLayout == 0)
        }
        self.contentConstraints = contentConstraints

        super.updateConstraints()
    }

}
