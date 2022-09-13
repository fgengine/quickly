//
//  Quickly
//

import UIKit

open class QCollectionStyleSheet : IQStyleSheet {
    
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
    public var allowsMultipleSelection: Bool

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
        allowsMultipleSelection: Bool = false
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
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    public init(_ styleSheet: QCollectionStyleSheet) {
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
        self.allowsMultipleSelection = styleSheet.allowsMultipleSelection
    }

}

open class QCollectionView : UICollectionView, IQView {

    public var collectionController: IQCollectionController? {
        willSet {
            self.delegate = nil
            self.dataSource = nil
            if #available(iOS 11.0, *) {
                if self.dragDelegate === self.collectionController {
                   self.dragDelegate = nil
                }
                if self.dropDelegate === self.collectionController {
                   self.dropDelegate = nil
                }
            }
            if let collectionController = self.collectionController {
                collectionController.collectionView = nil
            }
        }
        didSet {
            self.delegate = self.collectionController
            self.dataSource = self.collectionController
            if #available(iOS 11.0, *) {
                if let dragDelegate = self.collectionController as? UICollectionViewDragDelegate {
                    self.dragDelegate = dragDelegate
                }
                if let dropDelegate = self.collectionController as? UICollectionViewDropDelegate {
                    self.dropDelegate = dropDelegate
                }
            }
            if let collectionController = self.collectionController {
                collectionController.collectionView = self
            }
        }
    }
    open override var refreshControl: UIRefreshControl? {
        set(value) {
            if #available(iOS 10, *) {
                super.refreshControl = value
            } else {
                self._refreshControl = value
            }
        }
        get {
            if #available(iOS 10, *) {
                return super.refreshControl
            } else {
                return self._refreshControl
            }
        }
    }
    open var contentLeftInset: CGFloat = 0
    open var contentRightInset: CGFloat = 0

    private var _refreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self._refreshControl else { return }
            self.addSubview(refreshControl)
        }
        didSet {
            guard let refreshControl = self._refreshControl else { return }
            refreshControl.removeFromSuperview()
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        self.setup()
    }

    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.setup()
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
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
    }
    
    public func apply(_ styleSheet: QCollectionStyleSheet) {
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
        self.allowsMultipleSelection = styleSheet.allowsMultipleSelection
    }

}

extension QCollectionView : IQContainerSpec {
    
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
