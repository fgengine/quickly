//
//  Quickly
//

#if os(iOS)

    @IBDesignable
    public final class QSystemSpinnerView: QSpinnerView {

        public var color: UIColor? {
            set(value) { self.indicatorView.color = value }
            get { return self.indicatorView.color }
        }
        public var style: UIActivityIndicatorViewStyle {
            set(value) { self.indicatorView.activityIndicatorViewStyle = value }
            get { return self.indicatorView.activityIndicatorViewStyle }
        }

        public private(set) var indicatorView: UIActivityIndicatorView!

        open override var intrinsicContentSize: CGSize {
            get {
                return self.indicatorView.intrinsicContentSize
            }
        }

        open override func setup() {
            super.setup()

            self.backgroundColor = UIColor.clear

            self.indicatorView = UIActivityIndicatorView(frame: self.bounds)
            self.indicatorView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            self.addSubview(self.indicatorView)
        }

        open override func isAnimating() -> Bool  {
            return self.indicatorView.isAnimating
        }

        open override func start() {
            self.indicatorView.startAnimating()
        }

        open override func stop() {
            self.indicatorView.stopAnimating()
        }

        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            return self.indicatorView.sizeThatFits(size)
        }

        open override func sizeToFit() {
            return self.indicatorView.sizeToFit()
        }

    }

#endif

