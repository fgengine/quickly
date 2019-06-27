//
//  Quickly
//

open class QSpinnerViewStyleSheet : IQStyleSheet {
    
    var style: UIActivityIndicatorView.Style
    var color: UIColor?
    
    public init(
        style: UIActivityIndicatorView.Style = .white,
        color: UIColor? = nil
    ) {
        self.style = style
        self.color = color
    }
    
    public init(_ styleSheet: QSpinnerViewStyleSheet) {
        self.style = styleSheet.style
        self.color = styleSheet.color
    }
    
}

open class QSpinnerView : QView, IQSpinnerView {
    
    public var style: UIActivityIndicatorView.Style {
        set(value) {
            if self._view.style != value {
                let color = self._view.color
                self._view.style = value
                self._view.color = color
            }
        }
        get { return self._view.style }
    }
    public var color: UIColor? {
        set(value) { self._view.color = value }
        get { return self._view.color }
    }

    private var _view: UIActivityIndicatorView!

    open override var intrinsicContentSize: CGSize {
        get { return self._view.intrinsicContentSize }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self._view = UIActivityIndicatorView(frame: self.bounds)
        self._view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self._view)
    }

    open func isAnimating() -> Bool  {
        return self._view.isAnimating
    }

    open func start() {
        self._view.startAnimating()
    }

    open func stop() {
        self._view.stopAnimating()
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
    
    public func apply(_ styleSheet: QSpinnerViewStyleSheet) {
        self.style = styleSheet.style
        self.color = styleSheet.color
    }

}
