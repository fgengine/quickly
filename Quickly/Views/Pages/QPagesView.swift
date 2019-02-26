//
//  Quickly
//

open class QPagesView : QView, IQPagesView {

    open var numberOfPages: UInt {
        set(value) { self._pageControl.numberOfPages = Int(value) }
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
    open override var intrinsicContentSize: CGSize {
        get { return self._pageControl.intrinsicContentSize }
    }
    
    private var _pageControl: UIPageControl!
    
    open override func setup() {
        super.setup()
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        
        self._pageControl = UIPageControl(frame: self.bounds)
        self._pageControl.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(self._pageControl)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self._pageControl.sizeThatFits(size)
    }
    
    open override func sizeToFit() {
        self._pageControl.sizeToFit()
        self.frame = CGRect(
            origin: self.frame.origin,
            size: self._pageControl.frame.size
        )
    }

}
