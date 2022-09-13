//
//  Quickly
//

import UIKit

open class QTableStyleSheet : IQStyleSheet {
    
    public var backgroundColor: UIColor?
    public var isDirectionalLockEnabled: Bool
    public var bounces: Bool
    public var alwaysBounceVertical: Bool
    public var alwaysBounceHorizontal: Bool
    public var isPagingEnabled: Bool
    public var isScrollEnabled: Bool
    public var showsVerticalScrollIndicator: Bool
    public var showsHorizontalScrollIndicator: Bool
    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle
    public var decelerationRate: UIScrollView.DecelerationRate
    public var indexDisplayMode: UIScrollView.IndexDisplayMode
    public var allowsSelection: Bool
    public var allowsSelectionDuringEditing: Bool
    public var allowsMultipleSelection: Bool
    public var allowsMultipleSelectionDuringEditing: Bool
    public var separatorStyle: UITableViewCell.SeparatorStyle
    public var separatorColor: UIColor?
    public var separatorEffect: UIVisualEffect?
    public var remembersLastFocusedIndexPath: Bool

    public init(
        backgroundColor: UIColor,
        isDirectionalLockEnabled: Bool = false,
        bounces: Bool = true,
        alwaysBounceVertical: Bool = false,
        alwaysBounceHorizontal: Bool = false,
        isPagingEnabled: Bool = false,
        isScrollEnabled: Bool = true,
        showsVerticalScrollIndicator: Bool = true,
        showsHorizontalScrollIndicator: Bool = true,
        scrollIndicatorStyle: UIScrollView.IndicatorStyle = .default,
        decelerationRate: UIScrollView.DecelerationRate = .normal,
        indexDisplayMode: UIScrollView.IndexDisplayMode = .automatic,
        allowsSelection: Bool = true,
        allowsSelectionDuringEditing: Bool = false,
        allowsMultipleSelection: Bool = false,
        allowsMultipleSelectionDuringEditing: Bool = false,
        separatorStyle: UITableViewCell.SeparatorStyle = .singleLine,
        separatorColor: UIColor? = .gray,
        separatorEffect: UIVisualEffect? = nil,
        remembersLastFocusedIndexPath: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.isDirectionalLockEnabled = isDirectionalLockEnabled
        self.bounces = bounces
        self.alwaysBounceVertical = alwaysBounceVertical
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
        self.isPagingEnabled = isPagingEnabled
        self.isScrollEnabled = isScrollEnabled
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.scrollIndicatorStyle = scrollIndicatorStyle
        self.decelerationRate = decelerationRate
        self.indexDisplayMode = indexDisplayMode
        self.allowsSelection = allowsSelection
        self.allowsSelectionDuringEditing = allowsSelectionDuringEditing
        self.allowsMultipleSelection = allowsMultipleSelection
        self.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        self.separatorStyle = separatorStyle
        self.separatorColor = separatorColor
        self.separatorEffect = separatorEffect
        self.remembersLastFocusedIndexPath = remembersLastFocusedIndexPath
    }

    public init(_ styleSheet: QTableStyleSheet) {
        self.backgroundColor = styleSheet.backgroundColor
        self.isDirectionalLockEnabled = styleSheet.isDirectionalLockEnabled
        self.bounces = styleSheet.bounces
        self.alwaysBounceVertical = styleSheet.alwaysBounceVertical
        self.alwaysBounceHorizontal = styleSheet.alwaysBounceHorizontal
        self.isPagingEnabled = styleSheet.isPagingEnabled
        self.isScrollEnabled = styleSheet.isScrollEnabled
        self.showsVerticalScrollIndicator = styleSheet.showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = styleSheet.showsHorizontalScrollIndicator
        self.scrollIndicatorStyle = styleSheet.scrollIndicatorStyle
        self.decelerationRate = styleSheet.decelerationRate
        self.indexDisplayMode = styleSheet.indexDisplayMode
        self.allowsSelection = styleSheet.allowsSelection
        self.allowsSelectionDuringEditing = styleSheet.allowsSelectionDuringEditing
        self.allowsMultipleSelection = styleSheet.allowsMultipleSelection
        self.allowsMultipleSelectionDuringEditing = styleSheet.allowsMultipleSelectionDuringEditing
        self.separatorStyle = styleSheet.separatorStyle
        self.separatorColor = styleSheet.separatorColor
        self.separatorEffect = styleSheet.separatorEffect
        self.remembersLastFocusedIndexPath = styleSheet.remembersLastFocusedIndexPath
    }

}

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
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0.0
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
    
    public func apply(_ styleSheet: QTableStyleSheet) {
        self.backgroundColor = styleSheet.backgroundColor
        self.isDirectionalLockEnabled = styleSheet.isDirectionalLockEnabled
        self.bounces = styleSheet.bounces
        self.alwaysBounceVertical = styleSheet.alwaysBounceVertical
        self.alwaysBounceHorizontal = styleSheet.alwaysBounceHorizontal
        self.isPagingEnabled = styleSheet.isPagingEnabled
        self.isScrollEnabled = styleSheet.isScrollEnabled
        self.showsVerticalScrollIndicator = styleSheet.showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = styleSheet.showsHorizontalScrollIndicator
        self.indicatorStyle = styleSheet.scrollIndicatorStyle
        self.decelerationRate = styleSheet.decelerationRate
        self.indexDisplayMode = styleSheet.indexDisplayMode
        self.allowsSelection = styleSheet.allowsSelection
        self.allowsSelectionDuringEditing = styleSheet.allowsSelectionDuringEditing
        self.allowsMultipleSelection = styleSheet.allowsMultipleSelection
        self.allowsMultipleSelectionDuringEditing = styleSheet.allowsMultipleSelectionDuringEditing
        self.separatorStyle = styleSheet.separatorStyle
        self.separatorColor = styleSheet.separatorColor
        self.separatorEffect = styleSheet.separatorEffect
        self.remembersLastFocusedIndexPath = styleSheet.remembersLastFocusedIndexPath
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
    
    public var containerSize: CGSize {
        get { return self.bounds.inset(by: self.contentInset).size }
    }
    
    public var containerLeftInset: CGFloat {
        get { return self.contentLeftInset }
    }
    
    public var containerRightInset: CGFloat {
        get { return self.contentRightInset }
    }
    
}
