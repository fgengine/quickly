//
//  Quickly
//

open class QTableView : UITableView, IQView {

    open var stretchFooterView: UIView? {
        willSet {
            if let view = self.stretchFooterView { view.removeFromSuperview() }
        }
        didSet {
            if let view = self.stretchFooterView { self.addSubview(view) }
        }
    }
    public var tableController: IQTableController? {
        willSet {
            self.delegate = nil
            self.dataSource = nil
            if let tableController = self.tableController {
                tableController.tableView = nil
            }
        }
        didSet {
            self.delegate = self.tableController
            self.dataSource = self.tableController
            if let tableController = self.tableController {
                tableController.tableView = self
            }
        }
    }
    open override var refreshControl: UIRefreshControl? {
        set(value) {
            if #available(iOS 10, *) {
                super.refreshControl = value
            } else {
                self._legacyRefreshControl = value
            }
        }
        get {
            if #available(iOS 10, *) {
                return super.refreshControl
            } else {
                return self._legacyRefreshControl
            }
        }
    }
    open var contentLeftInset: CGFloat = 0
    open var contentRightInset: CGFloat = 0

    private var _legacyRefreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self._legacyRefreshControl else { return }
            self.addSubview(refreshControl)
        }
        didSet {
            guard let refreshControl = self._legacyRefreshControl else { return }
            refreshControl.removeFromSuperview()
        }
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
        self.backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            self.automaticallyAdjustsScrollIndicatorInsets = false
        }
    }
    
    open override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let view = self.stretchFooterView {
            let selfFrame = self.frame
            let contentOffset = self.contentOffset.y
            let contentHeight = self.contentSize.height
            var contentInset: UIEdgeInsets
            if #available(iOS 11.0, *) {
                contentInset = self.adjustedContentInset
            } else {
                contentInset = self.contentInset
            }
            let fullContentHeight = contentInset.top + contentHeight
            let contentBottomEdge = (contentOffset + contentInset.top) + selfFrame.height
            view.frame = CGRect(
                x: 0,
                y: contentHeight,
                width: selfFrame.size.width,
                height: max(contentBottomEdge - fullContentHeight, 0)
            )
        }
    }
    
}

// MARK: Private

private extension QTableView {
    
    func _tableFooterDefaultFrame(_ view: UIView) -> CGFloat {
        return view.frame.height
    }
    
    func _tableFooterStretchFrame(_ view: UIView, minimum: CGFloat) -> CGFloat {
        let contentOffset = self.contentOffset.y
        let contentHeight = self.contentSize.height
        var contentInset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            contentInset = self.adjustedContentInset
        } else {
            contentInset = self.contentInset
        }
        let fullContentHeight = contentInset.top + contentHeight
        let contentBottomEdge = (contentOffset + contentInset.top) + self.frame.height
        return max(minimum, contentBottomEdge - fullContentHeight)
    }

}

// MARK: IQContainerSpec

extension QTableView : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.bounds.inset(by: self.contentInset).size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.contentLeftInset }
    }
    open var containerRightInset: CGFloat {
        get { return self.contentRightInset }
    }
    
}
