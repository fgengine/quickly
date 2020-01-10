//
//  Quickly
//

open class QProgressLoadingView : QView, IQProgressLoadingView {
    
    public weak var delegate: IQLoadingViewDelegate?
    public var progress: CGFloat {
        set(value) { self.progressView.progress = value }
        get { return self.progressView.progress }
    }

    public var showDuration: TimeInterval = 0.2
    public var hideDuration: TimeInterval = 0.2
    
    public private(set) lazy var panelView: QDisplayView = {
        let view = QDisplayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public var panelInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    public private(set) var progressView: QProgressViewType
    public var spinnerPosition: QProgressLoadingView.Position = .top

    public var detailLabel: QLabel? {
        willSet {
            if let detailLabel = self.detailLabel {
                detailLabel.removeFromSuperview()
            }
        }
        didSet {
            if let detailLabel = self.detailLabel {
                detailLabel.translatesAutoresizingMaskIntoConstraints = false
                self.panelView.addSubview(detailLabel)
            }
            self._relayout()
        }
    }
    public var detailSpacing: CGFloat = 12

    private var _counter: UInt = 0
    private var __constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.__constraints) }
        didSet { self.addConstraints(self.__constraints) }
    }
    private var _panelConstraints: [NSLayoutConstraint] = [] {
        willSet { self.panelView.removeConstraints(self._panelConstraints) }
        didSet { self.panelView.addConstraints(self._panelConstraints) }
    }
    
    public init(progressView: QProgressViewType) {
        self.progressView = progressView
        super.init()
    }
    
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.progressView.removeFromSuperview()
    }
    
    open override func setup() {
        super.setup()
        
        self.alpha = 0

        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.panelView.addSubview(self.progressView)
        
        self.addSubview(self.panelView)
        
        self.__constraints = [
            self.panelView.centerXLayout == self.centerXLayout,
            self.panelView.centerYLayout == self.centerYLayout
        ]
        self._relayout()
    }
    
    open func isAnimating() -> Bool  {
        return self._counter > 0
    }
    
    open func start() {
        self._counter += 1
        if self._counter == 1 {
            if let delegate = self.delegate {
                delegate.willShow(loadingView: self)
            }
            self.progressView.progress = 0
            UIView.animate(withDuration: self.showDuration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.alpha = 1
            })
        }
    }
    
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        self.progressView.setProgress(progress, animated: animated)
    }
    
    open func stop() {
        if self._counter == 1 {
            self._counter = 0
            UIView.animate(withDuration: self.hideDuration, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.alpha = 0
            }, completion: { [weak self] _ in self?._didStop() })
        } else if self._counter > 0 {
            self._counter -= 1
        }
    }
    
}

extension QProgressLoadingView {
    
    public enum Position : Int {
        case top
        case bottom
    }
    
}

extension QProgressLoadingView {
    
    private func _relayout() {
        var panelConstraints: [NSLayoutConstraint] = []
        if let detailLabel = self.detailLabel {
            switch self.spinnerPosition {
            case .top:
                panelConstraints.append(contentsOf: [
                    self.progressView.topLayout == self.panelView.topLayout.offset(self.panelInsets.top),
                    self.progressView.leadingLayout >= self.panelView.leadingLayout.offset(self.panelInsets.left),
                    self.progressView.trailingLayout <= self.panelView.trailingLayout.offset(-self.panelInsets.right),
                    self.progressView.centerXLayout == self.panelView.centerXLayout,
                    detailLabel.topLayout == self.progressView.bottomLayout.offset(self.detailSpacing),
                    detailLabel.leadingLayout >= self.panelView.leadingLayout.offset(self.panelInsets.left),
                    detailLabel.trailingLayout <= self.panelView.trailingLayout.offset(-self.panelInsets.right),
                    detailLabel.bottomLayout == self.panelView.bottomLayout.offset(-self.panelInsets.bottom),
                    detailLabel.centerXLayout == self.panelView.centerXLayout
                ])
            case .bottom:
                panelConstraints.append(contentsOf: [
                    detailLabel.topLayout == self.panelView.topLayout.offset(self.panelInsets.top),
                    detailLabel.leadingLayout >= self.panelView.leadingLayout.offset(self.panelInsets.left),
                    detailLabel.trailingLayout <= self.panelView.trailingLayout.offset(-self.panelInsets.right),
                    detailLabel.centerXLayout == self.panelView.centerXLayout,
                    self.progressView.topLayout == detailLabel.bottomLayout.offset(-self.detailSpacing),
                    self.progressView.leadingLayout >= self.panelView.leadingLayout.offset(self.panelInsets.left),
                    self.progressView.trailingLayout <= self.panelView.trailingLayout.offset(-self.panelInsets.right),
                    self.progressView.bottomLayout == self.panelView.bottomLayout.offset(-self.panelInsets.bottom),
                    self.progressView.centerXLayout == self.panelView.centerXLayout
                ])
            }
        } else {
            panelConstraints.append(contentsOf: [
                self.progressView.topLayout == self.panelView.topLayout.offset(self.panelInsets.top),
                self.progressView.leadingLayout == self.panelView.leadingLayout.offset(self.panelInsets.left),
                self.progressView.trailingLayout == self.panelView.trailingLayout.offset(-self.panelInsets.right),
                self.progressView.bottomLayout == self.panelView.bottomLayout.offset(-self.panelInsets.bottom)
            ])
        }
        self._panelConstraints = panelConstraints
    }
    
    private func _didStop() {
        self.progressView.progress = 1
        if let delegate = self.delegate {
            delegate.didHide(loadingView: self)
        }
    }
    
}
