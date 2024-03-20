//
//  Quickly
//

import UIKit

public class QHostingViewController : UIViewController, IQViewControllerDelegate {

    public var contentViewController: IQViewController {
        willSet {
            if self.isViewLoaded == true {
                self.contentViewController.willDismiss(animated: false)
                self.contentViewController.didDismiss(animated: false)
                if self.contentViewController.isLoaded == true {
                    self.contentViewController.view.removeFromSuperview()
                }
            }
        }
        didSet {
            self.contentViewController.delegate = self
            if self.isViewLoaded == true {
                self.contentViewController.view.frame = self.view.bounds
                if self._isShowedSecurityView == true {
                    if let securityView = self.securityView {
                        self.view.insertSubview(self.contentViewController.view, belowSubview: securityView)
                    } else {
                        self.view.addSubview(self.contentViewController.view)
                    }
                } else {
                    self.view.addSubview(self.contentViewController.view)
                }
                self.contentViewController.willPresent(animated: false)
                self.contentViewController.didPresent(animated: false)
            }
        }
    }
    public var securityView: QWindowSecurityViewType? {
        willSet {
            if self.isViewLoaded == true && self._isShowedSecurityView == true {
                if let securityView = self.securityView {
                    securityView.removeFromSuperview()
                }
            }
        }
        didSet {
            if self.isViewLoaded == true && self._isShowedSecurityView == true {
                if let securityView = self.securityView {
                    securityView.frame = self.view.bounds
                    self.view.addSubview(securityView)
                }
            }
        }
    }

    public override var prefersStatusBarHidden: Bool {
        get { return self.contentViewController.preferedStatusBarHidden() }
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return self.contentViewController.preferedStatusBarStyle() }
    }
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get { return self.contentViewController.preferedStatusBarAnimation() }
    }
    public override var shouldAutorotate: Bool {
        get { return true }
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return self.contentViewController.supportedOrientations() }
    }
    
    private var _isShowedSecurityView: Bool

    public init(_ contentViewController: IQViewController) {
        self.contentViewController = contentViewController
        self._isShowedSecurityView = false
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {
        self.contentViewController.delegate = self
    }

    public override func loadView() {
        self.view = QTransparentView(frame: UIScreen.main.bounds)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.contentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.willPresent(animated: false)
        self.contentViewController.didPresent(animated: false)
        
        if self._isShowedSecurityView == true {
            if let securityView = self.securityView {
                securityView.frame = self.view.bounds
                self.view.addSubview(securityView)
            }
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
        self.contentViewController.view.frame = self.view.bounds
        
        if let securityView = self.securityView {
            if securityView.superview == self.view {
                securityView.frame = self.view.bounds
            }
        }
    }

    public override func viewSafeAreaInsetsDidChange() {
        self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.contentViewController.willTransition(size: size)
        }, completion: { [unowned self] _ in
            self.contentViewController.didTransition(size: size)
        })
    }
    
    // MARK: Internal

    internal func _currentAdditionalEdgeInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets
        } else {
            return UIEdgeInsets(
                top: self.topLayoutGuide.length,
                left: 0,
                bottom: self.bottomLayoutGuide.length,
                right: 0
            )
        }
    }
    
    internal func _showSecurityView() {
        if self.isViewLoaded == true && self._isShowedSecurityView == false {
            if let securityView = self.securityView {
                self._isShowedSecurityView = true
                securityView.frame = self.view.bounds
                self.view.addSubview(securityView)
                securityView.show({ (completed) in
                })
            }
        }
    }
    
    internal func _hideSecurityView() {
        if self.isViewLoaded == true && self._isShowedSecurityView == true {
            if let securityView = self.securityView {
                self._isShowedSecurityView = false
                securityView.hide({ (completed) in
                    securityView.removeFromSuperview()
                })
            }
        }
    }
    
    // MARK: Private
    
    private func _interfaceOrientation() -> UIInterfaceOrientation {
        let supportedOrientations = self.supportedInterfaceOrientations
        switch UIDevice.current.orientation {
        case .unknown, .portrait, .faceUp, .faceDown:
            if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            }
            break
        case .portraitUpsideDown:
            if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            }
            break
        case .landscapeLeft:
            if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            }
            break
        case .landscapeRight:
            if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            }
            break
        @unknown default:
            break
        }
        return .unknown
    }

    // MARK: IQViewControllerDelegate

    public func requestUpdateStatusBar(viewController: IQViewController) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public func requestUpdateOrientation(viewController: IQViewController) {
        let interfaceOrientation = self._interfaceOrientation()
        var deviceOrientation = UIDevice.current.orientation
        switch interfaceOrientation {
        case .portrait: deviceOrientation = UIDeviceOrientation.portrait
        case .portraitUpsideDown: deviceOrientation = UIDeviceOrientation.portraitUpsideDown
        case .landscapeLeft: deviceOrientation = UIDeviceOrientation.landscapeLeft
        case .landscapeRight: deviceOrientation = UIDeviceOrientation.landscapeRight
        case .unknown: break
        @unknown default: break
        }
        if deviceOrientation != UIDevice.current.orientation {
            UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
        }
    }

}
