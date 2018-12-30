//
//  Application
//

open class QPincodeComposable : QComposable {

    public let title: QLabelStyleSheet
    public let titleSpacing: CGFloat
    
    public let pincode: QPincodeViewStyleSheet
    public let pincodeSpacing: CGFloat
    
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
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.pincode = pincode
        self.pincodeSpacing = pincodeSpacing
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
    
    open func styleSheet(error: String) -> QLabelStyleSheet {
        return QLabelStyleSheet(text: QText(error, font: UIFont.systemFont(ofSize: UIFont.systemFontSize), color: UIColor.red))
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
    
    private var _error: QLabelStyleSheet?
    
    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var pincode: QPincodeView = {
        let view = QPincodeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var errorLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button1: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 1) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button2: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 2) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button3: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 3) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button4: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 4) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button5: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 5) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button6: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 6) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button7: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 7) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button8: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 8) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button9: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 9) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button0: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 0) }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var buttonLeft: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.onPressed = { [weak self] _ in
            guard let strong = self else { return }
            strong.delegate?.pincodeCompositionLeftPressed(strong)
        }
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var buttonRight: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.onPressed = { [weak self] _ in
            guard let strong = self else { return }
            if strong.pincode.isEmpty == true {
                strong.delegate?.pincodeCompositionRightPressed(strong)
            } else {
                strong.pincode.removeLast()
                strong._updateRightButton()
            }
        }
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleSpacing: CGFloat?
    private var _pincodeSpacing: CGFloat?
    private var _errorVisible: Bool?
    private var _errorSpacing: CGFloat?
    private var _buttonsSpacing: UIOffset?
    private var _buttonsSize: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _button1Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button1.removeConstraints(self._button1Constraints) }
        didSet { self.button1.addConstraints(self._button1Constraints) }
    }
    private var _button2Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button2.removeConstraints(self._button2Constraints) }
        didSet { self.button2.addConstraints(self._button2Constraints) }
    }
    private var _button3Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button3.removeConstraints(self._button3Constraints) }
        didSet { self.button3.addConstraints(self._button3Constraints) }
    }
    private var _button4Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button4.removeConstraints(self._button4Constraints) }
        didSet { self.button4.addConstraints(self._button4Constraints) }
    }
    private var _button5Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button5.removeConstraints(self._button5Constraints) }
        didSet { self.button5.addConstraints(self._button5Constraints) }
    }
    private var _button6Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button6.removeConstraints(self._button6Constraints) }
        didSet { self.button6.addConstraints(self._button6Constraints) }
    }
    private var _button7Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button7.removeConstraints(self._button7Constraints) }
        didSet { self.button7.addConstraints(self._button7Constraints) }
    }
    private var _button8Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button8.removeConstraints(self._button8Constraints) }
        didSet { self.button8.addConstraints(self._button8Constraints) }
    }
    private var _button9Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button9.removeConstraints(self._button9Constraints) }
        didSet { self.button9.addConstraints(self._button9Constraints) }
    }
    private var _button0Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button0.removeConstraints(self._button0Constraints) }
        didSet { self.button0.addConstraints(self._button0Constraints) }
    }
    private var _buttonLeftConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonLeft.removeConstraints(self._buttonLeftConstraints) }
        didSet { self.buttonLeft.addConstraints(self._buttonLeftConstraints) }
    }
    private var _buttonRightConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonRight.removeConstraints(self._buttonRightConstraints) }
        didSet { self.buttonRight.addConstraints(self._buttonRightConstraints) }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        self.delegate = owner as? QPincodeCompositionDelegate
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        let errorVisible = (self._error != nil)
        if  self._edgeInsets != edgeInsets ||
            self._titleSpacing != composable.titleSpacing ||
            self._pincodeSpacing != composable.pincodeSpacing ||
            self._errorVisible != errorVisible ||
            self._errorSpacing != composable.errorSpacing ||
            self._buttonsSpacing != composable.buttonsSpacing
        {
            self._edgeInsets = edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._pincodeSpacing = composable.pincodeSpacing
            self._errorVisible = errorVisible
            self._errorSpacing = composable.errorSpacing
            self._buttonsSpacing = composable.buttonsSpacing
            
            var constraints: [NSLayoutConstraint] = []
            
            constraints.append(self.titleLabel.topLayout >= self.contentView.topLayout + edgeInsets.top)
            constraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            constraints.append(self.pincode.topLayout == self.titleLabel.bottomLayout + composable.titleSpacing)
            constraints.append(self.pincode.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.pincode.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            constraints.append(self.errorLabel.topLayout == self.pincode.bottomLayout + composable.errorSpacing)
            constraints.append(self.errorLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.errorLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            
            if errorVisible == true {
                constraints.append(self.button1.topLayout == self.errorLabel.bottomLayout + composable.pincodeSpacing)
            } else {
                constraints.append(self.button1.topLayout == self.pincode.bottomLayout + composable.pincodeSpacing)
            }
            constraints.append(self.button1.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.button1.trailingLayout == self.button2.leadingLayout - composable.buttonsSpacing.horizontal)
            
            constraints.append(self.button2.topLayout == self.button1.topLayout)
            constraints.append(self.button2.centerXLayout == self.contentView.centerXLayout)
            constraints.append(self.button2.bottomLayout == self.button1.bottomLayout)
            
            constraints.append(self.button3.topLayout == self.button2.topLayout)
            constraints.append(self.button3.leadingLayout == self.button2.trailingLayout + composable.buttonsSpacing.horizontal)
            constraints.append(self.button3.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            constraints.append(self.button3.bottomLayout == self.button2.bottomLayout)
            
            constraints.append(self.button4.topLayout == self.button1.bottomLayout + composable.buttonsSpacing.vertical)
            constraints.append(self.button4.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.button4.trailingLayout == self.button1.trailingLayout)
            
            constraints.append(self.button5.topLayout == self.button4.topLayout)
            constraints.append(self.button5.leadingLayout == self.button2.leadingLayout)
            constraints.append(self.button5.trailingLayout == self.button2.trailingLayout)
            constraints.append(self.button5.bottomLayout == self.button4.bottomLayout)
            
            constraints.append(self.button6.topLayout == self.button5.topLayout)
            constraints.append(self.button6.leadingLayout == self.button3.leadingLayout)
            constraints.append(self.button6.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            constraints.append(self.button6.bottomLayout == self.button5.bottomLayout)
            
            constraints.append(self.button7.topLayout == self.button4.bottomLayout + composable.buttonsSpacing.vertical)
            constraints.append(self.button7.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.button7.trailingLayout == self.button4.trailingLayout)
            
            constraints.append(self.button8.topLayout == self.button7.topLayout)
            constraints.append(self.button8.leadingLayout == self.button5.leadingLayout)
            constraints.append(self.button8.trailingLayout == self.button5.trailingLayout)
            constraints.append(self.button8.bottomLayout == self.button7.bottomLayout)
            
            constraints.append(self.button9.topLayout == self.button8.topLayout)
            constraints.append(self.button9.leadingLayout == self.button6.leadingLayout)
            constraints.append(self.button9.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            constraints.append(self.button9.bottomLayout == self.button8.bottomLayout)
            
            constraints.append(self.buttonLeft.topLayout == self.button0.topLayout)
            constraints.append(self.buttonLeft.bottomLayout == self.button0.bottomLayout)
            constraints.append(self.buttonLeft.leadingLayout >= self.contentView.leadingLayout + edgeInsets.left)
            constraints.append(self.buttonLeft.trailingLayout == self.button7.trailingLayout)
            
            constraints.append(self.button0.topLayout == self.button8.bottomLayout + composable.buttonsSpacing.vertical)
            constraints.append(self.button0.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            constraints.append(self.button0.leadingLayout == self.button8.leadingLayout)
            constraints.append(self.button0.trailingLayout == self.button8.trailingLayout)
            
            constraints.append(self.buttonRight.topLayout == self.button0.topLayout)
            constraints.append(self.buttonRight.bottomLayout == self.button0.bottomLayout)
            constraints.append(self.buttonRight.leadingLayout == self.button9.leadingLayout)
            constraints.append(self.buttonRight.trailingLayout <= self.contentView.trailingLayout - edgeInsets.right)
            
            self._constraints = constraints
        }
        if self._buttonsSize != composable.buttonsSize {
            self._buttonsSize = composable.buttonsSize
            
            self._button1Constraints = [
                self.button1.widthLayout == composable.buttonsSize,
                self.button1.heightLayout == composable.buttonsSize
            ]
            self._button2Constraints = [
                self.button2.widthLayout == composable.buttonsSize,
                self.button2.heightLayout == composable.buttonsSize
            ]
            self._button3Constraints = [
                self.button3.widthLayout == composable.buttonsSize,
                self.button3.heightLayout == composable.buttonsSize
            ]
            self._button4Constraints = [
                self.button4.widthLayout == composable.buttonsSize,
                self.button4.heightLayout == composable.buttonsSize
            ]
            self._button5Constraints = [
                self.button5.widthLayout == composable.buttonsSize,
                self.button5.heightLayout == composable.buttonsSize
            ]
            self._button6Constraints = [
                self.button6.widthLayout == composable.buttonsSize,
                self.button6.heightLayout == composable.buttonsSize
            ]
            self._button7Constraints = [
                self.button7.widthLayout == composable.buttonsSize,
                self.button7.heightLayout == composable.buttonsSize
            ]
            self._button8Constraints = [
                self.button8.widthLayout == composable.buttonsSize,
                self.button8.heightLayout == composable.buttonsSize
            ]
            self._button9Constraints = [
                self.button9.widthLayout == composable.buttonsSize,
                self.button9.heightLayout == composable.buttonsSize
            ]
            self._button0Constraints = [
                self.button0.widthLayout == composable.buttonsSize,
                self.button0.heightLayout == composable.buttonsSize
            ]
            self._buttonLeftConstraints = [
                self.buttonLeft.widthLayout >= composable.buttonsSize,
                self.buttonLeft.heightLayout >= composable.buttonsSize
            ]
            self._buttonRightConstraints = [
                self.buttonRight.widthLayout >= composable.buttonsSize,
                self.buttonRight.heightLayout >= composable.buttonsSize
            ]
        }
    }
    
    open override func apply(composable: QPincodeComposable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.pincode.apply(composable.pincode)
        if let error = self._error {
            self.errorLabel.apply(error)
        }
        self.button0.apply(composable.button0)
        self.button1.apply(composable.button1)
        self.button2.apply(composable.button2)
        self.button3.apply(composable.button3)
        self.button4.apply(composable.button4)
        self.button5.apply(composable.button5)
        self.button6.apply(composable.button6)
        self.button7.apply(composable.button7)
        self.button8.apply(composable.button8)
        self.button9.apply(composable.button9)
        if let buttonLeft = composable.buttonLeft {
            self.buttonLeft.apply(buttonLeft)
        }
        if self.pincode.isEmpty == true {
            if let buttonRight = composable.buttonRight {
                self.buttonRight.apply(buttonRight)
            }
        } else {
            self.buttonRight.apply(composable.buttonBackspace)
        }
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.errorLabel.alpha = (self._error != nil) ? 1 : 0
        self.buttonLeft.alpha = (composable.buttonLeft != nil) ? 1 : 0
        if (self.pincode.isEmpty == false) || (composable.buttonRight != nil) {
            self.buttonRight.alpha = 1
        } else {
            self.buttonRight.alpha = 0
        }
    }
    
    public func resetPincode() {
        self.pincode.text = ""
        self._updateRightButton()
    }
    
    public func showError(text: String) {
        if let composable = self.composable, let spec = self.spec {
            self._error = composable.styleSheet(error: text)
            self.errorLabel.apply(self._error!)
            self.preLayout(composable: composable, spec: spec)
            UIView.animate(withDuration: 0.125, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.postLayout(composable: composable, spec: spec)
                self.contentView.layoutIfNeeded()
            })
        } else {
            self._error = nil
        }
    }
    
    public func hideError() {
        if self._error != nil {
            self._error = nil
            if let composable = self.composable, let spec = self.spec {
                self.preLayout(composable: composable, spec: spec)
                UIView.animate(withDuration: 0.125, delay: 0, options: [ .beginFromCurrentState ], animations: {
                    self.postLayout(composable: composable, spec: spec)
                    self.contentView.layoutIfNeeded()
                })
            }
        }
    }
    
    private func _pressedButton(number: Int) {
        self.pincode.append(number: number)
        self._updateRightButton()
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
    
    private func _updateRightButton() {
        if let composable = self.composable {
            if self.pincode.isEmpty == true {
                if let buttonRight = composable.buttonRight {
                    self.buttonRight.apply(buttonRight)
                    self.buttonRight.alpha = 1
                } else {
                    self.buttonRight.alpha = 0
                }
            } else {
                self.buttonRight.apply(composable.buttonBackspace)
                self.buttonRight.alpha = 1
            }
        } else {
            self.buttonRight.alpha = 0
        }
    }
    
}
