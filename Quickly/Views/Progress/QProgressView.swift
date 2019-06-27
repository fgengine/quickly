//
//  Quickly
//

open class QProgressViewStyleSheet : IQStyleSheet {
    
    var style: UIProgressView.Style
    var trackTintColor: UIColor?
    var progressTintColor: UIColor?
    
    public init(
        style: UIProgressView.Style = .default,
        trackTintColor: UIColor? = nil,
        progressTintColor: UIColor? = nil
    ) {
        self.style = style
        self.trackTintColor = trackTintColor
        self.progressTintColor = progressTintColor
    }
    
    public init(_ styleSheet: QProgressViewStyleSheet) {
        self.style = styleSheet.style
        self.trackTintColor = styleSheet.trackTintColor
        self.progressTintColor = styleSheet.progressTintColor
    }
    
}

open class QProgressView : QView, IQProgressView {
    
    public var style: UIProgressView.Style {
        set(value) { self._view.progressViewStyle = value }
        get { return self._view.progressViewStyle }
    }
    public var trackTintColor: UIColor? {
        set(value) { self._view.trackTintColor = value }
        get { return self._view.trackTintColor }
    }
    public var progressTintColor: UIColor? {
        set(value) { self._view.progressTintColor = value }
        get { return self._view.progressTintColor }
    }
    open var progress: CGFloat {
        set(value) { self._view.progress = Float(value) }
        get { return CGFloat(self._view.progress) }
    }
    
    private var _view: UIProgressView!

    open override var intrinsicContentSize: CGSize {
        get { return self._view.intrinsicContentSize }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self._view = UIProgressView(frame: self.bounds)
        self._view.backgroundColor = UIColor.clear
        self._view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self._view)
    }
    
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        self._view.setProgress(Float(progress), animated: animated)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self._view.sizeThatFits(size)
    }

    open override func sizeToFit() {
        self._view.sizeToFit()
        self.frame = CGRect(
            origin: self.frame.origin,
            size: self._view.frame.size
        )
    }
    
    public func apply(_ styleSheet: QProgressViewStyleSheet) {
        self.style = styleSheet.style
        self.trackTintColor = styleSheet.trackTintColor
        self.progressTintColor = styleSheet.progressTintColor
    }

}
