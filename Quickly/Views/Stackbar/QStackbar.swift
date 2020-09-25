//
//  Quickly
//

open class QStackbar : QView {
    
    public enum DisplayMode {
        case `default`
        case onlyBottom
    }

    public var displayMode: DisplayMode = .default {
        didSet(oldValue) {
            if self.displayMode != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets() {
        didSet(oldValue) {
            if self.edgeInsets != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var contentSize: CGFloat = 50 {
        didSet(oldValue) {
            if self.contentSize != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var leftViewsOffset: CGFloat = 0 {
        didSet(oldValue) {
            if self.leftViewsOffset != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var leftViewsSpacing: CGFloat {
        set(value) { self._leftView.spacing = value }
        get { return self._leftView.spacing }
    }
    public var leftViews: [UIView] {
        set(value) {
            if self._leftView.views != value {
                self._leftView.views = value
                self.setNeedsUpdateConstraints()
            }
        }
        get { return self._leftView.views }
    }
    public var centerViewsSpacing: CGFloat {
        set(value) { self._centerView.spacing = value }
        get { return self._centerView.spacing }
    }
    public var centerViews: [UIView] {
        set(value) {
            if self._centerView.views != value {
                self._centerView.views = value
                self.setNeedsUpdateConstraints()
            }
        }
        get { return self._centerView.views }
    }
    public var rightViewsOffset: CGFloat = 0 {
        didSet(oldValue) {
            if self.rightViewsOffset != oldValue {
                self.setNeedsUpdateConstraints()
            }
        }
    }
    public var rightViewsSpacing: CGFloat {
        set(value) { self._rightView.spacing = value }
        get { return self._rightView.spacing }
    }
    public var rightViews: [UIView] {
        set(value) {
            if self._rightView.views != value {
                self._rightView.views = value
                self.setNeedsUpdateConstraints()
            }
        }
        get { return self._rightView.views }
    }
    public var bottomView: UIView? {
        willSet {
            guard let view = self.bottomView else { return }
            view.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let view = self.bottomView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.insertSubview(view, at: 0)
            self.setNeedsUpdateConstraints()
        }
    }
    public var backgroundView: UIView? {
        willSet {
            guard let view = self.backgroundView else { return }
            view.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let view = self.backgroundView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.insertSubview(view, at: 0)
            self.setNeedsUpdateConstraints()
        }
    }
    public var separatorView: UIView? {
        willSet {
            guard let view = self.separatorView else { return }
            self._separatorConstraint = nil
            view.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let view = self.separatorView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            self._separatorConstraint = NSLayoutConstraint(
                item: view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: self.separatorHeight
            )
            self.setNeedsUpdateConstraints()
        }
    }
    public var separatorHeight: CGFloat = 1 {
        didSet(oldValue) {
            if self.separatorHeight != oldValue {
                if let constraint = self._separatorConstraint {
                    constraint.constant = self.separatorHeight
                }
            }
        }
    }

    private var _contentView: UIView!
    private var _leftView: WrapView!
    private var _centerView: WrapView!
    private var _rightView: WrapView!
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }
    private var _contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self._contentView.removeConstraints(self._contentConstraints) }
        didSet { self._contentView.addConstraints(self._contentConstraints) }
    }
    private var _separatorConstraint: NSLayoutConstraint? {
        willSet {
            guard let view = self.separatorView, let constraint = self._separatorConstraint else { return }
            view.removeConstraint(constraint)
        }
        didSet {
            guard let view = self.separatorView, let constraint = self._separatorConstraint else { return }
            view.addConstraint(constraint)
        }
    }

    public required init() {
        super.init(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.white
        
        self._contentView = UIView(frame: self.bounds)
        self._contentView.translatesAutoresizingMaskIntoConstraints = false
        self._contentView.backgroundColor = UIColor.clear
        self.addSubview(self._contentView)

        self._leftView = WrapView(frame: self.bounds)
        self._leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self._contentView.addSubview(self._leftView)

        self._centerView = WrapView(frame: self.bounds)
        self._contentView.addSubview(self._centerView)

        self._rightView = WrapView(frame: self.bounds)
        self._rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self._contentView.addSubview(self._rightView)
    }

    open override func updateConstraints() {
        super.updateConstraints()

        var constraints: [NSLayoutConstraint] = []
        if let backgroundView = self.backgroundView {
            constraints.append(contentsOf: [
                backgroundView.topLayout == self.topLayout,
                backgroundView.leadingLayout == self.leadingLayout,
                backgroundView.trailingLayout == self.trailingLayout,
                backgroundView.bottomLayout == self.bottomLayout
            ])
        }
        if let separatorView = self.separatorView {
            constraints.append(contentsOf: [
                separatorView.topLayout == self.bottomLayout,
                separatorView.leadingLayout == self.leadingLayout,
                separatorView.trailingLayout == self.trailingLayout
            ])
        }
        switch self.displayMode {
        case .default:
            constraints.append(contentsOf: [
                self._contentView.topLayout == self.topLayout.offset(self.edgeInsets.top),
                self._contentView.leadingLayout == self.leadingLayout.offset(self.edgeInsets.left),
                self._contentView.trailingLayout == self.trailingLayout.offset(-self.edgeInsets.right)
            ])
            if let bottomView = self.bottomView {
                constraints.append(contentsOf: [
                    self._contentView.bottomLayout == bottomView.topLayout,
                    bottomView.leadingLayout == self.leadingLayout.offset(self.edgeInsets.left),
                    bottomView.trailingLayout == self.trailingLayout.offset(-self.edgeInsets.right),
                    bottomView.bottomLayout == self.bottomLayout.offset(-self.edgeInsets.bottom)
                ])
            } else {
                constraints.append(contentsOf: [
                    self._contentView.bottomLayout == self.bottomLayout.offset(-self.edgeInsets.bottom)
                ])
            }
        case .onlyBottom:
            constraints.append(contentsOf: [
                self._contentView.bottomLayout == self.topLayout.offset(-self.edgeInsets.top)
            ])
            if let bottomView = self.bottomView {
                constraints.append(contentsOf: [
                    bottomView.topLayout == self.topLayout.offset(self.edgeInsets.top),
                    bottomView.leadingLayout == self.leadingLayout.offset(self.edgeInsets.left),
                    bottomView.trailingLayout == self.trailingLayout.offset(-self.edgeInsets.right),
                    bottomView.bottomLayout == self.bottomLayout.offset(-self.edgeInsets.bottom)
                ])
            } else {
                constraints.append(contentsOf: [
                    self._contentView.bottomLayout == self.bottomLayout.offset(-self.edgeInsets.bottom)
                ])
            }
        }
        self._constraints = constraints
        
        var contentConstraints: [NSLayoutConstraint] = [
            self._contentView.heightLayout == self.contentSize,
            self._leftView.topLayout == self._contentView.topLayout,
            self._leftView.leadingLayout == self._contentView.leadingLayout,
            self._leftView.bottomLayout == self._contentView.bottomLayout,
            self._centerView.topLayout == self._contentView.topLayout,
            self._centerView.bottomLayout == self._contentView.bottomLayout,
            self._rightView.topLayout == self._contentView.topLayout,
            self._rightView.trailingLayout == self._contentView.trailingLayout,
            self._rightView.bottomLayout == self._contentView.bottomLayout
        ]
        if self.centerViews.count > 0 {
            if self.leftViews.count > 0 && self.rightViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._centerView.leadingLayout >= self._leftView.trailingLayout.offset(self.leftViewsOffset),
                    self._centerView.trailingLayout <= self._rightView.leadingLayout.offset(-self.rightViewsOffset),
                    self._centerView.centerXLayout == self._contentView.centerXLayout
                ])
            } else if self.leftViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._centerView.leadingLayout >= self._leftView.trailingLayout.offset(self.leftViewsOffset),
                    self._centerView.trailingLayout <= self._contentView.trailingLayout,
                    self._centerView.centerXLayout == self._contentView.centerXLayout
                ])
            } else if self.rightViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._centerView.leadingLayout >= self._contentView.leadingLayout,
                    self._centerView.trailingLayout <= self._rightView.leadingLayout.offset(-self.rightViewsOffset),
                    self._centerView.centerXLayout == self._contentView.centerXLayout
                ])
            } else {
                contentConstraints.append(contentsOf: [
                    self._centerView.leadingLayout == self._contentView.leadingLayout,
                    self._centerView.trailingLayout == self._contentView.trailingLayout,
                    self._centerView.centerXLayout == self._contentView.centerXLayout
                ])
            }
        } else {
            if self.leftViews.count > 0 && self.rightViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._leftView.trailingLayout >= self._rightView.trailingLayout.offset(self.leftViewsOffset + self.rightViewsOffset)
                ])
            } else if self.leftViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._leftView.trailingLayout <= self._contentView.trailingLayout
                ])
            } else if self.rightViews.count > 0 {
                contentConstraints.append(contentsOf: [
                    self._rightView.leadingLayout >= self._contentView.leadingLayout
                ])
            }
        }
        self._contentConstraints = contentConstraints
    }

    private class WrapView : QInvisibleView {

        public var spacing: CGFloat = 0 {
            didSet(oldValue) {
                if self.spacing != oldValue {
                    self.setNeedsUpdateConstraints()
                }
            }
        }
        public var views: [UIView] = [] {
            willSet {
                for view in self.views {
                    view.removeFromSuperview()
                }
            }
            didSet {
                for view in self.views {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.setContentCompressionResistancePriority(self.contentCompressionResistancePriority(for: .horizontal), for: .horizontal)
                    view.setContentCompressionResistancePriority(self.contentCompressionResistancePriority(for: .vertical), for: .vertical)
                    view.setContentHuggingPriority(self.contentHuggingPriority(for: .horizontal), for: .horizontal)
                    view.setContentHuggingPriority(self.contentHuggingPriority(for: .vertical), for: .vertical)
                    self.addSubview(view)
                }
                self.setNeedsUpdateConstraints()
            }
        }

        private var _constraints: [NSLayoutConstraint] = [] {
            willSet { self.removeConstraints(self._constraints) }
            didSet { self.addConstraints(self._constraints) }
        }

        public override func setup() {
            super.setup()

            self.backgroundColor = UIColor.clear

            self.translatesAutoresizingMaskIntoConstraints = false
        }

        public override func updateConstraints() {
            super.updateConstraints()

            var constraints: [NSLayoutConstraint] = []
            if self.views.count > 0 {
                var lastView: UIView? = nil
                for view in self.views {
                    constraints.append(view.topLayout == self.topLayout)
                    if let lastView = lastView {
                        constraints.append(view.leadingLayout == lastView.trailingLayout.offset(self.spacing))
                    } else {
                        constraints.append(view.leadingLayout == self.leadingLayout)
                    }
                    constraints.append(view.bottomLayout == self.bottomLayout)
                    lastView = view
                }
                if let lastView = lastView {
                    constraints.append(lastView.trailingLayout == self.trailingLayout)
                }
            } else {
                constraints.append(self.widthLayout == 0)
            }
            self._constraints = constraints
        }

    }

}
