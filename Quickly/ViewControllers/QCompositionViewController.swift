//
//  Quickly
//

open class QCompositionViewController< Composition: IQComposition > : QViewController, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController, IQJalousieContentViewController, IQLoadingViewDelegate {

    public var backgroundView: UIView? {
        willSet {
            guard let backgroundView = self.backgroundView else { return }
            backgroundView.removeFromSuperview()
        }
        didSet {
            guard let backgroundView = self.backgroundView else { return }
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.view.insertSubview(backgroundView, at: 0)
            self._updateConstraints(self.view, backgroundView: backgroundView)
        }
    }
    public private(set) lazy var composition: Composition = {
        let composition = Composition(frame: self.view.bounds, owner: self)
        composition.contentView.translatesAutoresizingMaskIntoConstraints = false
        if let backgroundView = self.backgroundView {
            self.view.insertSubview(composition.contentView, aboveSubview: backgroundView)
        } else {
            self.view.addSubview(composition.contentView)
        }
        self._updateConstraints(self.view, contentView: composition.contentView)
        return composition
    }()
    public var loadingView: QLoadingViewType? {
        willSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.removeFromSuperview()
            loadingView.delegate = nil
        }
        didSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.delegate = self
        }
    }
    
    private var _backgroundConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._backgroundConstraints) }
        didSet { self.view.addConstraints(self._backgroundConstraints) }
    }
    private var _contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._contentConstraints) }
        didSet { self.view.addConstraints(self._contentConstraints) }
    }
    private var _loadingConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._loadingConstraints) }
        didSet { self.view.addConstraints(self._loadingConstraints) }
    }
    
    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if self.isLoaded == true {
            self._updateConstraints(self.view, contentView: self.composition.contentView)
        }
    }
    
    open func isLoading() -> Bool {
        guard let loadingView = self.loadingView else { return false }
        return loadingView.isAnimating()
    }
    
    open func startLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.start()
    }
    
    open func stopLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.stop()
    }
    
    // MARK: IQContentViewController
    
    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }
    
    open func notifyBeginUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.beginUpdateContent()
        }
    }
    
    open func notifyUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if let viewController = self.contentOwnerViewController {
            return viewController.finishUpdateContent(velocity: velocity)
        }
        return nil
    }
    
    open func notifyEndUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.endUpdateContent()
        }
    }
    
    // MARK: IQModalContentViewController
    
    open func modalShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQDialogContentViewController
    
    open func dialogDidPressedOutside() {
    }
    
    // MARK: IQHamburgerContentViewController
    
    open func hamburgerShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQJalousieContentViewController
    
    open func jalousieShouldInteractive() -> Bool {
        return true
    }

    // MARK: IQLoadingViewDelegate

    open func willShow(loadingView: QLoadingViewType) {
        self.view.addSubview(loadingView)
        self._updateConstraints(self.view, loadingView: loadingView)
    }

    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}

// MARK: Private

private extension QCompositionViewController {
    
    func _updateConstraints(_ view: UIView, backgroundView: UIView) {
        self._backgroundConstraints = [
            backgroundView.topLayout == view.topLayout,
            backgroundView.leadingLayout == view.leadingLayout,
            backgroundView.trailingLayout == view.trailingLayout,
            backgroundView.bottomLayout == view.bottomLayout
        ]
    }
    
    func _updateConstraints(_ view: UIView, contentView: UIView) {
        let edgeInsets = self.inheritedEdgeInsets
        self._contentConstraints = [
            contentView.topLayout == view.topLayout.offset(edgeInsets.top),
            contentView.leadingLayout == view.leadingLayout.offset(edgeInsets.left),
            contentView.trailingLayout == view.trailingLayout.offset(-edgeInsets.right),
            contentView.bottomLayout == view.bottomLayout.offset(-edgeInsets.bottom)
        ]
    }
    
    func _updateConstraints(_ view: UIView, loadingView: QLoadingViewType) {
        self._loadingConstraints = [
            loadingView.topLayout == view.topLayout,
            loadingView.leadingLayout == view.leadingLayout,
            loadingView.trailingLayout == view.trailingLayout,
            loadingView.bottomLayout == view.bottomLayout
        ]
    }

}

// MARK: IQContainerSpec

extension QCompositionViewController : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.view.bounds.size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.inheritedEdgeInsets.left }
    }
    open var containerRightInset: CGFloat {
        get { return self.inheritedEdgeInsets.right }
    }
    
}

// MARK: IQTextFieldObserver

extension QCompositionViewController : IQTextFieldObserver {
    
    open func beginEditing(textField: QTextField) {
    }
    
    open func editing(textField: QTextField) {
    }
    
    open func endEditing(textField: QTextField) {
    }
    
    open func pressedCancel(textField: QTextField) {
    }
    
    open func pressedDone(textField: QTextField) {
    }
    
    open func pressedClear(textField: QTextField) {
    }
    
    open func pressedReturn(textField: QTextField) {
    }
    
    open func select(textField: QTextField, suggestion: String) {
    }
    
}

// MARK: IQMultiTextFieldObserver

extension QCompositionViewController : IQMultiTextFieldObserver {
    
    open func beginEditing(multiTextField: QMultiTextField) {
    }

    open func editing(multiTextField: QMultiTextField) {
    }

    open func endEditing(multiTextField: QMultiTextField) {
    }
    
    open func pressedCancel(multiTextField: QMultiTextField) {
    }
    
    open func pressedDone(multiTextField: QMultiTextField) {
    }

    open func changed(multiTextField: QMultiTextField, height: CGFloat) {
    }

}

// MARK: IQListFieldObserver

extension QCompositionViewController : IQListFieldObserver {
    
    open func beginEditing(listField: QListField) {
    }
    
    open func select(listField: QListField, row: QListFieldPickerRow) {
    }
    
    open func endEditing(listField: QListField) {
    }
    
    open func pressedCancel(listField: QListField) {
    }
    
    open func pressedDone(listField: QListField) {
    }
    
}

// MARK: IQDateFieldObserver

extension QCompositionViewController : IQDateFieldObserver {
    
    open func beginEditing(dateField: QDateField) {
    }
    
    open func select(dateField: QDateField, date: Date) {
    }
    
    open func endEditing(dateField: QDateField) {
    }
    
    open func pressedCancel(dateField: QDateField) {
    }
    
    open func pressedDone(dateField: QDateField) {
    }
    
}

