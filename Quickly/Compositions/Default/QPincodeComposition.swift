//
//  Application
//

open class QPincodeComposable : QComposable {

    public let title: QLabelStyleSheet
    public let titleSpacing: CGFloat
    
    public let pincode: QPincodeViewStyleSheet
    public let pincodeSpacing: CGFloat
    
    public let error: IQTextStyle
    public let errorSpacing: CGFloat
    
    public let button1: QButtonStyleSheet
    public let button2: QButtonStyleSheet
    public let button3: QButtonStyleSheet
    public let button4: QButtonStyleSheet
    public let button5: QButtonStyleSheet
    public let button6: QButtonStyleSheet
    public let button7: QButtonStyleSheet
    public let button8: QButtonStyleSheet
    public let button9: QButtonStyleSheet
    public let button0: QButtonStyleSheet
    public let buttonLeft: QButtonStyleSheet?
    public let buttonRight: QButtonStyleSheet?
    public let buttonBackspace: QButtonStyleSheet
    public let buttonsSpacing: UIOffset
    public let buttonsSize: CGFloat

    public init(
        title: QLabelStyleSheet,
        titleSpacing: CGFloat,
        pincode: QPincodeViewStyleSheet,
        pincodeSpacing: CGFloat,
        error: IQTextStyle,
        errorSpacing: CGFloat,
        button1: QButtonStyleSheet,
        button2: QButtonStyleSheet,
        button3: QButtonStyleSheet,
        button4: QButtonStyleSheet,
        button5: QButtonStyleSheet,
        button6: QButtonStyleSheet,
        button7: QButtonStyleSheet,
        button8: QButtonStyleSheet,
        button9: QButtonStyleSheet,
        button0: QButtonStyleSheet,
        buttonLeft: QButtonStyleSheet?,
        buttonRight: QButtonStyleSheet?,
        buttonBackspace: QButtonStyleSheet,
        buttonsSpacing: UIOffset,
        buttonsSize: CGFloat,
        edgeInsets: UIEdgeInsets = defaultEdgeInsets
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.pincode = pincode
        self.pincodeSpacing = pincodeSpacing
        self.error = error
        self.errorSpacing = errorSpacing
        self.button1 = button1
        self.button2 = button2
        self.button3 = button3
        self.button4 = button4
        self.button5 = button5
        self.button6 = button6
        self.button7 = button7
        self.button8 = button8
        self.button9 = button9
        self.button0 = button0
        self.buttonLeft = buttonLeft
        self.buttonRight = buttonRight
        self.buttonBackspace = buttonBackspace
        self.buttonsSpacing = buttonsSpacing
        self.buttonsSize = buttonsSize
        super.init(edgeInsets: edgeInsets)
    }

}

public protocol QPincodeCompositionDelegate : class {
    
    func pincodeCompositionUpdated(_ composition: QPincodeComposition, pin: String)
    func pincodeCompositionCompited(_ composition: QPincodeComposition, pin: String)
    func pincodeCompositionLeftPressed(_ composition: QPincodeComposition)
    func pincodeCompositionRightPressed(_ composition: QPincodeComposition)
    
}

open class QPincodeComposition : QComposition< QPincodeComposable > {
    
    open weak var delegate: QPincodeCompositionDelegate?
    
    private var error: QLabelStyleSheet?
    
    private var titleLabel: QLabel!
    private var pincode: QPincodeView!
    private var errorLabel: QLabel!
    private var button1: QButton!
    private var button2: QButton!
    private var button3: QButton!
    private var button4: QButton!
    private var button5: QButton!
    private var button6: QButton!
    private var button7: QButton!
    private var button8: QButton!
    private var button9: QButton!
    private var button0: QButton!
    private var buttonLeft: QButton!
    private var buttonRight: QButton!
    
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentPincodeSpacing: CGFloat?
    private var currentErrorVisible: Bool?
    private var currentErrorSpacing: CGFloat?
    private var currentButtonsSpacing: UIOffset?
    private var currentButtonsSize: CGFloat?
    
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var button1Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button1.removeConstraints(self.button1Constraints) }
        didSet { self.button1.addConstraints(self.button1Constraints) }
    }
    private var button2Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button2.removeConstraints(self.button2Constraints) }
        didSet { self.button2.addConstraints(self.button2Constraints) }
    }
    private var button3Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button3.removeConstraints(self.button3Constraints) }
        didSet { self.button3.addConstraints(self.button3Constraints) }
    }
    private var button4Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button4.removeConstraints(self.button4Constraints) }
        didSet { self.button4.addConstraints(self.button4Constraints) }
    }
    private var button5Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button5.removeConstraints(self.button5Constraints) }
        didSet { self.button5.addConstraints(self.button5Constraints) }
    }
    private var button6Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button6.removeConstraints(self.button6Constraints) }
        didSet { self.button6.addConstraints(self.button6Constraints) }
    }
    private var button7Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button7.removeConstraints(self.button7Constraints) }
        didSet { self.button7.addConstraints(self.button7Constraints) }
    }
    private var button8Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button8.removeConstraints(self.button8Constraints) }
        didSet { self.button8.addConstraints(self.button8Constraints) }
    }
    private var button9Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button9.removeConstraints(self.button9Constraints) }
        didSet { self.button9.addConstraints(self.button9Constraints) }
    }
    private var button0Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button0.removeConstraints(self.button0Constraints) }
        didSet { self.button0.addConstraints(self.button0Constraints) }
    }
    private var buttonLeftConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonLeft.removeConstraints(self.buttonLeftConstraints) }
        didSet { self.buttonLeft.addConstraints(self.buttonLeftConstraints) }
    }
    private var buttonRightConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonRight.removeConstraints(self.buttonRightConstraints) }
        didSet { self.buttonRight.addConstraints(self.buttonRightConstraints) }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        self.delegate = owner as? QPincodeCompositionDelegate
        
        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        
        self.pincode = QPincodeView(frame: self.contentView.bounds)
        self.pincode.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.pincode)
        
        self.errorLabel = QLabel(frame: self.contentView.bounds)
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.alpha = 0
        self.contentView.addSubview(self.errorLabel)
        
        self.button1 = QButton(frame: self.contentView.bounds)
        self.button1.translatesAutoresizingMaskIntoConstraints = false
        self.button1.addTouchUpInside(self, action: #selector(self.pressedButton1(_:)))
        self.contentView.addSubview(self.button1)
        
        self.button2 = QButton(frame: self.contentView.bounds)
        self.button2.translatesAutoresizingMaskIntoConstraints = false
        self.button2.addTouchUpInside(self, action: #selector(self.pressedButton2(_:)))
        self.contentView.addSubview(self.button2)
        
        self.button3 = QButton(frame: self.contentView.bounds)
        self.button3.translatesAutoresizingMaskIntoConstraints = false
        self.button3.addTouchUpInside(self, action: #selector(self.pressedButton3(_:)))
        self.contentView.addSubview(self.button3)
        
        self.button4 = QButton(frame: self.contentView.bounds)
        self.button4.translatesAutoresizingMaskIntoConstraints = false
        self.button4.addTouchUpInside(self, action: #selector(self.pressedButton4(_:)))
        self.contentView.addSubview(self.button4)
        
        self.button5 = QButton(frame: self.contentView.bounds)
        self.button5.translatesAutoresizingMaskIntoConstraints = false
        self.button5.addTouchUpInside(self, action: #selector(self.pressedButton5(_:)))
        self.contentView.addSubview(self.button5)
        
        self.button6 = QButton(frame: self.contentView.bounds)
        self.button6.translatesAutoresizingMaskIntoConstraints = false
        self.button6.addTouchUpInside(self, action: #selector(self.pressedButton6(_:)))
        self.contentView.addSubview(self.button6)
        
        self.button7 = QButton(frame: self.contentView.bounds)
        self.button7.translatesAutoresizingMaskIntoConstraints = false
        self.button7.addTouchUpInside(self, action: #selector(self.pressedButton7(_:)))
        self.contentView.addSubview(self.button7)
        
        self.button8 = QButton(frame: self.contentView.bounds)
        self.button8.translatesAutoresizingMaskIntoConstraints = false
        self.button8.addTouchUpInside(self, action: #selector(self.pressedButton8(_:)))
        self.contentView.addSubview(self.button8)
        
        self.button9 = QButton(frame: self.contentView.bounds)
        self.button9.translatesAutoresizingMaskIntoConstraints = false
        self.button9.addTouchUpInside(self, action: #selector(self.pressedButton9(_:)))
        self.contentView.addSubview(self.button9)
        
        self.button0 = QButton(frame: self.contentView.bounds)
        self.button0.translatesAutoresizingMaskIntoConstraints = false
        self.button0.addTouchUpInside(self, action: #selector(self.pressedButton0(_:)))
        self.contentView.addSubview(self.button0)
        
        self.buttonLeft = QButton(frame: self.contentView.bounds)
        self.buttonLeft.translatesAutoresizingMaskIntoConstraints = false
        self.buttonLeft.addTouchUpInside(self, action: #selector(self.pressedButtonLeft(_:)))
        self.buttonLeft.alpha = 0
        self.contentView.addSubview(self.buttonLeft)
        
        self.buttonRight = QButton(frame: self.contentView.bounds)
        self.buttonRight.translatesAutoresizingMaskIntoConstraints = false
        self.buttonRight.addTouchUpInside(self, action: #selector(self.pressedButtonRight(_:)))
        self.buttonRight.alpha = 0
        self.contentView.addSubview(self.buttonRight)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        self.preLayout(composable: composable, spec: spec)
        composable.title.apply(target: self.titleLabel)
        composable.pincode.apply(target: self.pincode)
        if let error = self.error {
            error.apply(target: self.errorLabel)
        }
        composable.button0.apply(target: self.button0)
        composable.button1.apply(target: self.button1)
        composable.button2.apply(target: self.button2)
        composable.button3.apply(target: self.button3)
        composable.button4.apply(target: self.button4)
        composable.button5.apply(target: self.button5)
        composable.button6.apply(target: self.button6)
        composable.button7.apply(target: self.button7)
        composable.button8.apply(target: self.button8)
        composable.button9.apply(target: self.button9)
        if let buttonLeft = composable.buttonLeft {
            buttonLeft.apply(target: self.buttonLeft)
        }
        if self.pincode.isEmpty == true {
            if let buttonRight = composable.buttonRight {
                buttonRight.apply(target: self.buttonRight)
            }
        } else {
            composable.buttonBackspace.apply(target: self.buttonRight)
        }
        self.postLayout(composable: composable, spec: spec)
    }
    
    public func resetPincode() {
        self.pincode.text = ""
        self.updateRightButton()
    }
    
    public func showError(text: String) {
        if let composable = self.composable, let spec = self.spec {
            self.error = QLabelStyleSheet(text: QStyledText(text, style: composable.error))
            self.error!.apply(target: self.errorLabel)
            self.preLayout(composable: composable, spec: spec)
            UIView.animate(withDuration: 0.125, animations: {
                self.postLayout(composable: composable, spec: spec)
                self.contentView.layoutIfNeeded()
            })
        } else {
            self.error = nil
        }
    }
    
    public func hideError() {
        if self.error != nil {
            self.error = nil
            if let composable = self.composable, let spec = self.spec {
                self.preLayout(composable: composable, spec: spec)
                UIView.animate(withDuration: 0.125, animations: {
                    self.postLayout(composable: composable, spec: spec)
                    self.contentView.layoutIfNeeded()
                })
            }
        }
    }
    
    private func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        let errorVisible = (self.error != nil)
        if  self.currentEdgeInsets != edgeInsets ||
            self.currentTitleSpacing != composable.titleSpacing ||
            self.currentPincodeSpacing != composable.pincodeSpacing ||
            self.currentErrorVisible != errorVisible ||
            self.currentErrorSpacing != composable.errorSpacing ||
            self.currentButtonsSpacing != composable.buttonsSpacing
        {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentPincodeSpacing = composable.pincodeSpacing
            self.currentErrorVisible = errorVisible
            self.currentErrorSpacing = composable.errorSpacing
            self.currentButtonsSpacing = composable.buttonsSpacing
            
            var selfConstraints: [NSLayoutConstraint] = []
            
            selfConstraints.append(self.titleLabel.topLayout >= self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            selfConstraints.append(self.pincode.topLayout == self.titleLabel.bottomLayout + composable.titleSpacing)
            selfConstraints.append(self.pincode.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.pincode.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            selfConstraints.append(self.errorLabel.topLayout == self.pincode.bottomLayout + composable.errorSpacing)
            selfConstraints.append(self.errorLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.errorLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            if errorVisible == true {
                selfConstraints.append(self.button1.topLayout == self.errorLabel.bottomLayout + composable.pincodeSpacing)
            } else {
                selfConstraints.append(self.button1.topLayout == self.pincode.bottomLayout + composable.pincodeSpacing)
            }
            selfConstraints.append(self.button1.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.button1.trailingLayout == self.button2.leadingLayout - composable.buttonsSpacing.horizontal)

            selfConstraints.append(self.button2.topLayout == self.button1.topLayout)
            selfConstraints.append(self.button2.centerXLayout == self.contentView.centerXLayout)
            selfConstraints.append(self.button2.bottomLayout == self.button1.bottomLayout)

            selfConstraints.append(self.button3.topLayout == self.button2.topLayout)
            selfConstraints.append(self.button3.leadingLayout == self.button2.trailingLayout + composable.buttonsSpacing.horizontal)
            selfConstraints.append(self.button3.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.button3.bottomLayout == self.button2.bottomLayout)

            selfConstraints.append(self.button4.topLayout == self.button1.bottomLayout + composable.buttonsSpacing.vertical)
            selfConstraints.append(self.button4.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.button4.trailingLayout == self.button1.trailingLayout)
            
            selfConstraints.append(self.button5.topLayout == self.button4.topLayout)
            selfConstraints.append(self.button5.leadingLayout == self.button2.leadingLayout)
            selfConstraints.append(self.button5.trailingLayout == self.button2.trailingLayout)
            selfConstraints.append(self.button5.bottomLayout == self.button4.bottomLayout)
            
            selfConstraints.append(self.button6.topLayout == self.button5.topLayout)
            selfConstraints.append(self.button6.leadingLayout == self.button3.leadingLayout)
            selfConstraints.append(self.button6.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.button6.bottomLayout == self.button5.bottomLayout)
            
            selfConstraints.append(self.button7.topLayout == self.button4.bottomLayout + composable.buttonsSpacing.vertical)
            selfConstraints.append(self.button7.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.button7.trailingLayout == self.button4.trailingLayout)
            
            selfConstraints.append(self.button8.topLayout == self.button7.topLayout)
            selfConstraints.append(self.button8.leadingLayout == self.button5.leadingLayout)
            selfConstraints.append(self.button8.trailingLayout == self.button5.trailingLayout)
            selfConstraints.append(self.button8.bottomLayout == self.button7.bottomLayout)
            
            selfConstraints.append(self.button9.topLayout == self.button8.topLayout)
            selfConstraints.append(self.button9.leadingLayout == self.button6.leadingLayout)
            selfConstraints.append(self.button9.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.button9.bottomLayout == self.button8.bottomLayout)
            
            selfConstraints.append(self.buttonLeft.topLayout == self.button0.topLayout)
            selfConstraints.append(self.buttonLeft.bottomLayout == self.button0.bottomLayout)
            selfConstraints.append(self.buttonLeft.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.buttonLeft.trailingLayout == self.button7.trailingLayout)
            
            selfConstraints.append(self.button0.topLayout == self.button8.bottomLayout + composable.buttonsSpacing.vertical)
            selfConstraints.append(self.button0.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.button0.leadingLayout == self.button8.leadingLayout)
            selfConstraints.append(self.button0.trailingLayout == self.button8.trailingLayout)
            
            selfConstraints.append(self.buttonRight.topLayout == self.button0.topLayout)
            selfConstraints.append(self.buttonRight.bottomLayout == self.button0.bottomLayout)
            selfConstraints.append(self.buttonRight.leadingLayout == self.button9.leadingLayout)
            selfConstraints.append(self.buttonRight.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            
            self.selfConstraints = selfConstraints
        }
        if self.currentButtonsSize != composable.buttonsSize {
            self.currentButtonsSize = composable.buttonsSize
            
            self.button1Constraints = [
                self.button1.widthLayout == composable.buttonsSize,
                self.button1.heightLayout == composable.buttonsSize
            ]
            self.button2Constraints = [
                self.button2.widthLayout == composable.buttonsSize,
                self.button2.heightLayout == composable.buttonsSize
            ]
            self.button3Constraints = [
                self.button3.widthLayout == composable.buttonsSize,
                self.button3.heightLayout == composable.buttonsSize
            ]
            self.button4Constraints = [
                self.button4.widthLayout == composable.buttonsSize,
                self.button4.heightLayout == composable.buttonsSize
            ]
            self.button5Constraints = [
                self.button5.widthLayout == composable.buttonsSize,
                self.button5.heightLayout == composable.buttonsSize
            ]
            self.button6Constraints = [
                self.button6.widthLayout == composable.buttonsSize,
                self.button6.heightLayout == composable.buttonsSize
            ]
            self.button7Constraints = [
                self.button7.widthLayout == composable.buttonsSize,
                self.button7.heightLayout == composable.buttonsSize
            ]
            self.button8Constraints = [
                self.button8.widthLayout == composable.buttonsSize,
                self.button8.heightLayout == composable.buttonsSize
            ]
            self.button9Constraints = [
                self.button9.widthLayout == composable.buttonsSize,
                self.button9.heightLayout == composable.buttonsSize
            ]
            self.button0Constraints = [
                self.button0.widthLayout == composable.buttonsSize,
                self.button0.heightLayout == composable.buttonsSize
            ]
            self.buttonLeftConstraints = [
                self.buttonLeft.widthLayout >= composable.buttonsSize,
                self.buttonLeft.heightLayout >= composable.buttonsSize
            ]
            self.buttonRightConstraints = [
                self.buttonRight.widthLayout >= composable.buttonsSize,
                self.buttonRight.heightLayout >= composable.buttonsSize
            ]
        }
    }
    
    private func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.errorLabel.alpha = (self.error != nil) ? 1 : 0
        self.buttonLeft.alpha = (composable.buttonLeft != nil) ? 1 : 0
        if (self.pincode.isEmpty == false) || (composable.buttonRight != nil) {
            self.buttonRight.alpha = 1
        } else {
            self.buttonRight.alpha = 0
        }
    }
    
    @objc
    private func pressedButton0(_ sender: Any?) {
        self.pressedButton(number: 0)
    }
    
    @objc
    private func pressedButton1(_ sender: Any?) {
        self.pressedButton(number: 1)
    }
    
    @objc
    private func pressedButton2(_ sender: Any?) {
        self.pressedButton(number: 2)
    }
    
    @objc
    private func pressedButton3(_ sender: Any?) {
        self.pressedButton(number: 3)
    }
    
    @objc
    private func pressedButton4(_ sender: Any?) {
        self.pressedButton(number: 4)
    }
    
    @objc
    private func pressedButton5(_ sender: Any?) {
        self.pressedButton(number: 5)
    }
    
    @objc
    private func pressedButton6(_ sender: Any?) {
        self.pressedButton(number: 6)
    }
    
    @objc
    private func pressedButton7(_ sender: Any?) {
        self.pressedButton(number: 7)
    }
    
    @objc
    private func pressedButton8(_ sender: Any?) {
        self.pressedButton(number: 8)
    }
    
    @objc
    private func pressedButton9(_ sender: Any?) {
        self.pressedButton(number: 9)
    }
    
    @objc
    private func pressedButtonLeft(_ sender: Any?) {
        if let delegate = self.delegate {
            delegate.pincodeCompositionLeftPressed(self)
        }
    }
    
    @objc
    private func pressedButtonRight(_ sender: Any?) {
        if self.pincode.isEmpty == true {
            if let delegate = self.delegate {
                delegate.pincodeCompositionRightPressed(self)
            }
        } else {
            self.pincode.removeLast()
            self.updateRightButton()
        }
    }
    
    private func pressedButton(number: Int) {
        self.pincode.append(number: number)
        self.updateRightButton()
        if self.pincode.isFilled == true {
            if let delegate = self.delegate {
                delegate.pincodeCompositionCompited(self, pin: self.pincode.text)
            }
        } else {
            if let delegate = self.delegate {
                delegate.pincodeCompositionUpdated(self, pin: self.pincode.text)
            }
        }
    }
    
    private func updateRightButton() {
        if let composable = self.composable {
            if self.pincode.isEmpty == true {
                if let buttonRight = composable.buttonRight {
                    buttonRight.apply(target: self.buttonRight)
                    self.buttonRight.alpha = 1
                } else {
                    self.buttonRight.alpha = 0
                }
            } else {
                composable.buttonBackspace.apply(target: self.buttonRight)
                self.buttonRight.alpha = 1
            }
        } else {
            self.buttonRight.alpha = 0
        }
    }
    
}
