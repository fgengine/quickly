//
//  Quickly
//

import UIKit

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
    
    private lazy var _view: UIProgressView = {
        let view = UIProgressView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        return view
    }()

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addConstraints([
            self._view.topLayout == self.topLayout,
            self._view.leadingLayout == self.leadingLayout,
            self._view.trailingLayout == self.trailingLayout,
            self._view.bottomLayout == self.bottomLayout
        ])
    }
    
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        self._view.setProgress(Float(progress), animated: animated)
    }
    
    public func apply(_ styleSheet: QProgressViewStyleSheet) {
        self.style = styleSheet.style
        self.trackTintColor = styleSheet.trackTintColor
        self.progressTintColor = styleSheet.progressTintColor
    }

}
