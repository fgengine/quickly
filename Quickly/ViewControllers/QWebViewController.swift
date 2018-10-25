//
//  Quickly
//

open class QWebViewController : QViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController {
    
    #if DEBUG
    open override var logging: Bool {
        get { return true }
    }
    #endif
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
    public var leftEdgeInset: CGFloat = 0
    public var rightEdgeInset: CGFloat = 0
    public var allowInvalidCertificates: Bool = false
    public var localCertificateUrls: [URL] = []
    public private(set) lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds.inset(by: self.inheritedEdgeInsets), configuration: self.prepareConfiguration())
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        self.view.addSubview(webView)
        return webView
    }()
    
    deinit {
        if self.isLoaded == true {
            self.webView.scrollView.delegate = nil
            self.webView.navigationDelegate = nil
            self.webView.uiDelegate = nil
        }
    }
    
    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self)
    }
    
    open override func layout(bounds: CGRect) {
        self.webView.frame = view.bounds.inset(by: self.inheritedEdgeInsets)
    }
    
    open func prepareConfiguration() -> WKWebViewConfiguration {
        return WKWebViewConfiguration()
    }
    
    @discardableResult
    open func load(url: URL) -> WKNavigation? {
        return self.webView.load(URLRequest(url: url))
    }
    
    @discardableResult
    open func load(request: URLRequest) -> WKNavigation? {
        return self.webView.load(request)
    }
    
    @discardableResult
    open func load(fileUrl: URL, readAccessURL: URL) -> WKNavigation? {
        return self.webView.loadFileURL(fileUrl, allowingReadAccessTo: readAccessURL)
    }
    
    @discardableResult
    open func load(html: String, baseUrl: URL?) -> WKNavigation? {
        return self.webView.loadHTMLString(html, baseURL: baseUrl)
    }
    
    @discardableResult
    open func load(data: Data, mimeType: String, encoding: String, baseUrl: URL) -> WKNavigation? {
        return self.webView.load(data, mimeType: mimeType, characterEncodingName: encoding, baseURL: baseUrl)
    }
    
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let challenge = QImplAuthenticationChallenge(
            localCertificateUrls: self.localCertificateUrls,
            allowInvalidCertificates: self.allowInvalidCertificates,
            challenge: challenge
        )
        completionHandler(challenge.disposition, challenge.credential)
        
    }
    
}
