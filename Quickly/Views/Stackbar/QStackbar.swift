//
//  Quickly
//

open class QStackbar : QView {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets() {
        didSet(oldValue) {
            if self.edgeInsets != oldValue {
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
    public var backgroundView: UIView? {
        willSet {
            guard let backgroundView = self.backgroundView else { return }
            backgroundView.removeFromSuperview()
            self.setNeedsUpdateConstraints()
        }
        didSet {
            guard let backgroundView = self.backgroundView else { return }
            self.insertSubview(backgroundView, at: 0)
            self.setNeedsUpdateConstraints()
        }
    }

    private var _leftView: WrapView!
    private var _centerView: WrapView!
    private var _rightView: WrapView!

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
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

        self._leftView = WrapView(frame: self.bounds)
        self._leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.addSubview(self._leftView)

        self._centerView = WrapView(frame: self.bounds)
        self._centerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.addSubview(self._centerView)

        self._rightView = WrapView(frame: self.bounds)
        self._rightView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.addSubview(self._rightView)
    }

    open override func updateConstraints() {
        super.updateConstraints()

        let leftViewsCount = self.leftViews.count
        let centerViewsCount = self.centerViews.count
        let rightViewsCount = self.rightViews.count

        var constraints: [NSLayoutConstraint] = []
        if let backgroundView = self.backgroundView {
            constraints.append(backgroundView.topLayout == self.topLayout)
            constraints.append(backgroundView.leadingLayout == self.leadingLayout)
            constraints.append(backgroundView.trailingLayout == self.trailingLayout)
            constraints.append(backgroundView.bottomLayout == self.bottomLayout)
        }
        constraints.append(self._leftView.topLayout == self.topLayout + self.edgeInsets.top)
        constraints.append(self._leftView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
        constraints.append(self._leftView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        constraints.append(self._centerView.topLayout == self.topLayout + self.edgeInsets.top)
        if centerViewsCount > 0 {
            if leftViewsCount > 0 && rightViewsCount > 0 {
                constraints.append(self._centerView.leadingLayout >= self._leftView.trailingLayout + self.leftViewsOffset)
                constraints.append(self._centerView.trailingLayout <= self._rightView.leadingLayout - self.rightViewsOffset)
            } else if leftViewsCount > 0 {
                constraints.append(self._centerView.leadingLayout >= self._leftView.trailingLayout + self.leftViewsOffset)
                constraints.append(self._centerView.trailingLayout <= self.trailingLayout - self.edgeInsets.right)
            } else if rightViewsCount > 0 {
                constraints.append(self._centerView.leadingLayout >= self.leadingLayout + self.edgeInsets.left)
                constraints.append(self._centerView.trailingLayout <= self._rightView.leadingLayout - self.rightViewsOffset)
            } else {
                constraints.append(self._centerView.leadingLayout == self.leadingLayout + self.edgeInsets.left)
                constraints.append(self._centerView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
            }
            constraints.append(self._centerView.centerXLayout == self.centerXLayout)
        } else {
            if leftViewsCount > 0 && rightViewsCount > 0 {
                constraints.append(self._leftView.trailingLayout >= self._rightView.trailingLayout + self.leftViewsOffset + self.rightViewsOffset)
            } else if leftViewsCount > 0 {
                constraints.append(self._leftView.trailingLayout <= self.trailingLayout - self.edgeInsets.right)
            } else if rightViewsCount > 0 {
                constraints.append(self._rightView.leadingLayout >= self.leadingLayout + self.edgeInsets.left)
            }
        }
        constraints.append(self._centerView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        constraints.append(self._rightView.topLayout == self.topLayout + self.edgeInsets.top)
        constraints.append(self._rightView.trailingLayout == self.trailingLayout - self.edgeInsets.right)
        constraints.append(self._rightView.bottomLayout == self.bottomLayout - self.edgeInsets.bottom)
        self._constraints = constraints
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
                        constraints.append(view.leadingLayout == lastView.trailingLayout + self.spacing)
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
