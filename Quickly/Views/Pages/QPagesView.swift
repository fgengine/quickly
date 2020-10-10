//
//  Quickly
//

open class QPagesViewStyleSheet : IQStyleSheet {
    
    var hidesForSinglePage: Bool
    var pageIndicatorColor: UIColor?
    var currentPageIndicatorColor: UIColor?
    
    public init(
        hidesForSinglePage: Bool = true,
        pageIndicatorColor: UIColor? = nil,
        currentPageIndicatorColor: UIColor? = nil
    ) {
        self.hidesForSinglePage = hidesForSinglePage
        self.pageIndicatorColor = pageIndicatorColor
        self.currentPageIndicatorColor = currentPageIndicatorColor
    }
    
    public init(_ styleSheet: QPagesViewStyleSheet) {
        self.hidesForSinglePage = styleSheet.hidesForSinglePage
        self.pageIndicatorColor = styleSheet.pageIndicatorColor
        self.currentPageIndicatorColor = styleSheet.currentPageIndicatorColor
    }
    
}

open class QPagesView : QView, IQPagesView {

    open var numberOfPages: UInt {
        set(value) {
            self._pageControl.numberOfPages = Int(value)
            self.invalidateIntrinsicContentSize()
        }
        get { return UInt(self._pageControl.numberOfPages) }
    }
    open var currentPage: UInt {
        set(value) { self._pageControl.currentPage = Int(value) }
        get { return UInt(self._pageControl.currentPage) }
    }
    open var currentProgress: CGFloat {
        set(value) { self._pageControl.currentPage = Int(value) }
        get { return CGFloat(self._pageControl.currentPage) }
    }
    open var hidesForSinglePage: Bool {
        set(value) { self._pageControl.hidesForSinglePage = value }
        get { return self._pageControl.hidesForSinglePage }
    }
    open var pageIndicatorColor: UIColor? {
        set(value) { self._pageControl.pageIndicatorTintColor = value }
        get { return self._pageControl.pageIndicatorTintColor }
    }
    open var currentPageIndicatorColor: UIColor? {
        set(value) { self._pageControl.currentPageIndicatorTintColor = value }
        get { return self._pageControl.currentPageIndicatorTintColor }
    }
    
    private var _pageControl: UIPageControl!
    
    open override func setup() {
        super.setup()
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        
        self._pageControl = UIPageControl(frame: self.bounds)
        self._pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self._pageControl)
        self.addConstraints([
            self.topLayout >= self._pageControl.topLayout,
            self.leadingLayout >= self._pageControl.leadingLayout,
            self.trailingLayout <= self._pageControl.trailingLayout,
            self.bottomLayout <= self._pageControl.bottomLayout,
            self.centerXLayout == self._pageControl.centerXLayout,
            self.centerYLayout == self._pageControl.centerYLayout
        ])
    }
    
    public func apply(_ styleSheet: QPagesViewStyleSheet) {
        self.hidesForSinglePage = styleSheet.hidesForSinglePage
        self.pageIndicatorColor = styleSheet.pageIndicatorColor
        self.currentPageIndicatorColor = styleSheet.currentPageIndicatorColor
    }

}
