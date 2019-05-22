//
//  Quickly
//

open class QWebViewController : QViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController {
    
    public var contentOffset: CGPoint {
        get {
            guard self.isLoaded == true else { return CGPoint.zero }
            return self.webView.scrollView.contentOffset
        }
    }
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.webView.scrollView.contentSize
        }
    }
    public var allowInvalidCertificates: Bool = false
    public var localCertificateUrls: [URL] = []
    public private(set) lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds, configuration: self.prepareConfiguration())
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView.scrollView.delegate = self
        self.view.addSubview(webView)
        return webView
    }()
    public var loadingView: QLoadingViewType? {
        willSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.removeFromSuperview()
            loadingView.delegate = nil
        }
        didSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.delegate = self
        }
    }
    
    deinit {
        if self.isLoaded == true {
            self.webView.scrollView.delegate = nil
            self.webView.navigationDelegate = nil
            self.webView.uiDelegate = nil
        }
    }
    
    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        self.webView.frame = bounds
        if let view = self.loadingView, view.superview == self.view {
            self._updateFrame(loadingView: view, bounds: bounds)
        }
    }
    
    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if self.isLoaded == true {
            self._updateContentInsets(webView: self.webView)
            if let view = self.loadingView, view.superview != nil {
                self._updateFrame(loadingView: view, bounds: self.view.bounds)
            }
        }
    }    
    open func prepareConfiguration() -> WKWebViewConfiguration {
        return WKWebViewConfiguration()
    }
    
    @discardableResult
    open func load(url: URL) -> WKNavigation? {
        let navigation = self.webView.load(URLRequest(url: url))
        if navigation != nil {
            self.startLoading()
        }
        return navigation
    }
    
    @discardableResult
    open func load(request: URLRequest) -> WKNavigation? {
        let navigation = self.webView.load(request)
        if navigation != nil {
            self.startLoading()
        }
        return navigation
    }
    
    @discardableResult
    open func load(fileUrl: URL, readAccessURL: URL) -> WKNavigation? {
        let navigation = self.webView.loadFileURL(fileUrl, allowingReadAccessTo: readAccessURL)
        if navigation != nil {
            self.startLoading()
        }
        return navigation
    }
    
    @discardableResult
    open func load(html: String, baseUrl: URL?) -> WKNavigation? {
        let navigation = self.webView.loadHTMLString(html, baseURL: baseUrl)
        if navigation != nil {
            self.startLoading()
        }
        return navigation
    }
    
    @discardableResult
    open func load(data: Data, mimeType: String, encoding: String, baseUrl: URL) -> WKNavigation? {
        let navigation = self.webView.load(data, mimeType: mimeType, characterEncodingName: encoding, baseURL: baseUrl)
        if navigation != nil {
            self.startLoading()
        }
        return navigation
    }
    
    open func dialogDidPressedOutside() {
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
    
    // MARK: WKNavigationDelegate
    
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let challenge = QImplAuthenticationChallenge(
            localCertificateUrls: self.localCertificateUrls,
            allowInvalidCertificates: self.allowInvalidCertificates,
            challenge: challenge
        )
        completionHandler(challenge.disposition, challenge.credential)
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopLoading()
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopLoading()
    }
    
    // MARK: Private
    
    private func _updateContentInsets(webView: WKWebView) {
        let edgeInsets = self.adjustedContentInset
        webView.scrollView.contentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom,
            right: 0
        )
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom,
            right: edgeInsets.right
        )
    }
    
    private func _updateFrame(loadingView: QLoadingViewType, bounds: CGRect) {
        loadingView.frame = bounds.inset(by: self.inheritedEdgeInsets)
    }
    
}

extension QWebViewController : IQLoadingViewDelegate {
    
    open func willShow(loadingView: QLoadingViewType) {
        self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        self.view.addSubview(loadingView)
    }
    
    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}
