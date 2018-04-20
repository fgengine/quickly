//
//  Quickly
//

open class QCollectionViewController : QViewController, IQCollectionControllerObserver, IQStackContentViewController {

    open var stackPageViewController: IQStackPageViewController?
    open var stackPageContentOffset: CGPoint {
        get {
            guard self.isLoaded == true else { return CGPoint.zero }
            let contentOffset = self.collectionView.contentOffset
            let contentInset = self.collectionView.contentInset
            return CGPoint(
                x: contentInset.left + contentOffset.x,
                y: contentInset.top + contentOffset.y
            )
        }
    }
    open var stackPageContentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.collectionView.contentSize
        }
    }

    public var collectionController: IQCollectionController? {
        set(value) {
            if let controller = self.collectionView.collectionController {
                controller.removeObserver(self)
            }
            self.collectionView.collectionController = value
            if let controller = self.collectionView.collectionController {
                controller.addObserver(self)
            }
        }
        get {return self.collectionView.collectionController }
    }
    open var refreshControlHidden: Bool = false {
        didSet { self.updateRefreshControlState() }
    }
    public var refreshControl: UIRefreshControl? {
        set(value) {
            if let refreshControl = self.storeRefreshControl {
                if refreshControl.isRefreshing == true {
                    refreshControl.endRefreshing()
                }
            }
            self.storeRefreshControl = value
            self.updateRefreshControlState()
        }
        get { return self.storeRefreshControl }
    }
    open var isRefreshing: Bool {
        get {
            guard let refreshControl = self.storeRefreshControl else { return false }
            return refreshControl.isRefreshing
        }
    }

    private var collectionView: QCollectionView! {
        willSet {
            guard let view = self.collectionView else { return }
            view.removeFromSuperview()
        }
        didSet {
            guard let view = self.collectionView else { return }
            let edgeInsets = self.inheritedEdgeInsets
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
            self.view.addSubview(view)
        }
    }
    private var storeRefreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.removeValueChanged(self, action: #selector(self.triggeredRefreshControl(_:)))
        }
        didSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.addValueChanged(self, action: #selector(self.triggeredRefreshControl(_:)))
        }
    }

    open override func didLoad() {
        self.collectionView = QCollectionView(frame: self.view.bounds, layout: QCollectionFlowLayout())
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds : bounds)

        if let view = self.collectionView {
            let edgeInsets = self.inheritedEdgeInsets
            if let layout = view.collectionLayout {
                let beforeContentInset = view.contentInset
                let beforeContentOffset = view.contentOffset
                let beforeContentSize = layout.collectionViewContentSize
                let progress = CGPoint(
                    x: (beforeContentInset.left + beforeContentOffset.x) / beforeContentSize.width,
                    y: (beforeContentInset.top + beforeContentOffset.y) / beforeContentSize.height
                )
                view.frame = bounds
                view.contentInset = edgeInsets
                view.scrollIndicatorInsets = edgeInsets
                let afterContentSize = layout.collectionViewContentSize
                view.contentOffset = CGPoint(
                    x: -edgeInsets.left + (afterContentSize.width * progress.x),
                    y: -edgeInsets.top + (afterContentSize.height * progress.y)
                )
            } else {
                view.frame = bounds
                view.contentInset = edgeInsets
                view.scrollIndicatorInsets = edgeInsets
            }
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)

        self.updateRefreshControlState()
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)

        self.updateRefreshControlState()
    }

    open func beginRefreshing() {
        guard let refreshControl = self.storeRefreshControl else { return }
        refreshControl.beginRefreshing()
    }

    open func endRefreshing() {
        guard let refreshControl = self.storeRefreshControl else { return }
        refreshControl.endRefreshing()
    }

    open func triggeredRefreshControl() {
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        guard let stackPage = self.stackPageViewController else { return }
        stackPage.updateContent()
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        guard let stackPage = self.stackPageViewController else { return }
        stackPage.updateContent()
    }

    open func update(_ controller: IQCollectionController) {
    }

    @objc
    private func triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func updateRefreshControlState() {
        if self.isLoaded == true {
            if self.refreshControlHidden == false && self.isPresented == true {
                self.collectionView.refreshControl = self.storeRefreshControl
            } else {
                if let refreshControl = self.storeRefreshControl {
                    refreshControl.endRefreshing()
                }
                self.collectionView.refreshControl = nil
            }
        }
    }

}
