//
//  Docusketch
//

open class QPincodeComposable : QComposable {

    public let titleStyle: QLabelStyleSheet
    public let titleSpacing: CGFloat
    
    public let pincodeStyle: QPincodeStyleSheet
    public let pincodeSpacing: CGFloat
    
    public let errorSpacing: CGFloat
    
    public let button1Style: QButtonStyleSheet
    public let button2Style: QButtonStyleSheet
    public let button3Style: QButtonStyleSheet
    public let button4Style: QButtonStyleSheet
    public let button5Style: QButtonStyleSheet
    public let button6Style: QButtonStyleSheet
    public let button7Style: QButtonStyleSheet
    public let button8Style: QButtonStyleSheet
    public let button9Style: QButtonStyleSheet
    public let button0Style: QButtonStyleSheet
    public let buttonLeftStyle: QButtonStyleSheet?
    public let buttonRightStyle: QButtonStyleSheet?
    public let buttonBackspaceStyle: QButtonStyleSheet
    public let buttonsSpacing: UIOffset
    public let buttonsSize: CGFloat

    public init(
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat,
        pincodeStyle: QPincodeStyleSheet,
        pincodeSpacing: CGFloat,
        errorSpacing: CGFloat,
        button1Style: QButtonStyleSheet,
        button2Style: QButtonStyleSheet,
        button3Style: QButtonStyleSheet,
        button4Style: QButtonStyleSheet,
        button5Style: QButtonStyleSheet,
        button6Style: QButtonStyleSheet,
        button7Style: QButtonStyleSheet,
        button8Style: QButtonStyleSheet,
        button9Style: QButtonStyleSheet,
        button0Style: QButtonStyleSheet,
        buttonLeftStyle: QButtonStyleSheet?,
        buttonRightStyle: QButtonStyleSheet?,
        buttonBackspaceStyle: QButtonStyleSheet,
        buttonsSpacing: UIOffset,
        buttonsSize: CGFloat,
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    ) {
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.pincodeStyle = pincodeStyle
        self.pincodeSpacing = pincodeSpacing
        self.errorSpacing = errorSpacing
        self.button1Style = button1Style
        self.button2Style = button2Style
        self.button3Style = button3Style
        self.button4Style = button4Style
        self.button5Style = button5Style
        self.button6Style = button6Style
        self.button7Style = button7Style
        self.button8Style = button8Style
        self.button9Style = button9Style
        self.button0Style = button0Style
        self.buttonLeftStyle = buttonLeftStyle
        self.buttonRightStyle = buttonRightStyle
        self.buttonBackspaceStyle = buttonBackspaceStyle
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
    
    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var pincodeView: QPincodeView = {
        let view = QPincodeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var errorView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button1View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 1) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button2View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 2) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button3View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 3) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button4View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 4) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button5View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 5) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button6View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 6) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button7View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 7) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button8View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 8) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button9View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 9) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var button0View: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in self?._pressedButton(number: 0) }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var buttonLeftView: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.onPressed = { [weak self] _ in
            guard let self = self, let delegate = self.delegate else { return }
            delegate.pincodeCompositionLeftPressed(self)
        }
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var buttonRightView: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.onPressed = { [weak self] _ in
            guard let self = self else { return }
            if self.pincodeView.isEmpty == true {
                if let delegate = self.delegate {
                    delegate.pincodeCompositionRightPressed(self)
                }
            } else {
                self.pincodeView.removeLast()
                self._updateRightButton()
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
        willSet { self.button1View.removeConstraints(self._button1Constraints) }
        didSet { self.button1View.addConstraints(self._button1Constraints) }
    }
    private var _button2Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button2View.removeConstraints(self._button2Constraints) }
        didSet { self.button2View.addConstraints(self._button2Constraints) }
    }
    private var _button3Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button3View.removeConstraints(self._button3Constraints) }
        didSet { self.button3View.addConstraints(self._button3Constraints) }
    }
    private var _button4Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button4View.removeConstraints(self._button4Constraints) }
        didSet { self.button4View.addConstraints(self._button4Constraints) }
    }
    private var _button5Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button5View.removeConstraints(self._button5Constraints) }
        didSet { self.button5View.addConstraints(self._button5Constraints) }
    }
    private var _button6Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button6View.removeConstraints(self._button6Constraints) }
        didSet { self.button6View.addConstraints(self._button6Constraints) }
    }
    private var _button7Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button7View.removeConstraints(self._button7Constraints) }
        didSet { self.button7View.addConstraints(self._button7Constraints) }
    }
    private var _button8Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button8View.removeConstraints(self._button8Constraints) }
        didSet { self.button8View.addConstraints(self._button8Constraints) }
    }
    private var _button9Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button9View.removeConstraints(self._button9Constraints) }
        didSet { self.button9View.addConstraints(self._button9Constraints) }
    }
    private var _button0Constraints: [NSLayoutConstraint] = [] {
        willSet { self.button0View.removeConstraints(self._button0Constraints) }
        didSet { self.button0View.addConstraints(self._button0Constraints) }
    }
    private var _buttonLeftConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonLeftView.removeConstraints(self._buttonLeftConstraints) }
        didSet { self.buttonLeftView.addConstraints(self._buttonLeftConstraints) }
    }
    private var _buttonRightConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonRightView.removeConstraints(self._buttonRightConstraints) }
        didSet { self.buttonRightView.addConstraints(self._buttonRightConstraints) }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)
        
        self.delegate = owner as? QPincodeCompositionDelegate
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let errorVisible = (self._error != nil)
        if  self._edgeInsets != composable.edgeInsets ||
            self._titleSpacing != composable.titleSpacing ||
            self._pincodeSpacing != composable.pincodeSpacing ||
            self._errorVisible != errorVisible ||
            self._errorSpacing != composable.errorSpacing ||
            self._buttonsSpacing != composable.buttonsSpacing
        {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._pincodeSpacing = composable.pincodeSpacing
            self._errorVisible = errorVisible
            self._errorSpacing = composable.errorSpacing
            self._buttonsSpacing = composable.buttonsSpacing
            
            var constraints: [NSLayoutConstraint] = []
            
            constraints.append(self.titleView.topLayout >= self.contentView.topLayout.offset(composable.edgeInsets.top))
            constraints.append(self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            
            constraints.append(self.pincodeView.topLayout == self.titleView.bottomLayout.offset(composable.titleSpacing))
            constraints.append(self.pincodeView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.pincodeView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            
            constraints.append(self.errorView.topLayout == self.pincodeView.bottomLayout.offset(composable.errorSpacing))
            constraints.append(self.errorView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.errorView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            
            if errorVisible == true {
                constraints.append(self.button1View.topLayout == self.errorView.bottomLayout.offset(composable.pincodeSpacing))
            } else {
                constraints.append(self.button1View.topLayout == self.pincodeView.bottomLayout.offset(composable.pincodeSpacing))
            }
            constraints.append(self.button1View.leadingLayout >= self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.button1View.trailingLayout == self.button2View.leadingLayout.offset(-composable.buttonsSpacing.horizontal))
            
            constraints.append(self.button2View.topLayout == self.button1View.topLayout)
            constraints.append(self.button2View.centerXLayout == self.contentView.centerXLayout)
            constraints.append(self.button2View.bottomLayout == self.button1View.bottomLayout)
            
            constraints.append(self.button3View.topLayout == self.button2View.topLayout)
            constraints.append(self.button3View.leadingLayout == self.button2View.trailingLayout.offset(composable.buttonsSpacing.horizontal))
            constraints.append(self.button3View.trailingLayout <= self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            constraints.append(self.button3View.bottomLayout == self.button2View.bottomLayout)
            
            constraints.append(self.button4View.topLayout == self.button1View.bottomLayout.offset(composable.buttonsSpacing.vertical))
            constraints.append(self.button4View.leadingLayout >= self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.button4View.trailingLayout == self.button1View.trailingLayout)
            
            constraints.append(self.button5View.topLayout == self.button4View.topLayout)
            constraints.append(self.button5View.leadingLayout == self.button2View.leadingLayout)
            constraints.append(self.button5View.trailingLayout == self.button2View.trailingLayout)
            constraints.append(self.button5View.bottomLayout == self.button4View.bottomLayout)
            
            constraints.append(self.button6View.topLayout == self.button5View.topLayout)
            constraints.append(self.button6View.leadingLayout == self.button3View.leadingLayout)
            constraints.append(self.button6View.trailingLayout <= self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            constraints.append(self.button6View.bottomLayout == self.button5View.bottomLayout)
            
            constraints.append(self.button7View.topLayout == self.button4View.bottomLayout.offset(composable.buttonsSpacing.vertical))
            constraints.append(self.button7View.leadingLayout >= self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.button7View.trailingLayout == self.button4View.trailingLayout)
            
            constraints.append(self.button8View.topLayout == self.button7View.topLayout)
            constraints.append(self.button8View.leadingLayout == self.button5View.leadingLayout)
            constraints.append(self.button8View.trailingLayout == self.button5View.trailingLayout)
            constraints.append(self.button8View.bottomLayout == self.button7View.bottomLayout)
            
            constraints.append(self.button9View.topLayout == self.button8View.topLayout)
            constraints.append(self.button9View.leadingLayout == self.button6View.leadingLayout)
            constraints.append(self.button9View.trailingLayout <= self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            constraints.append(self.button9View.bottomLayout == self.button8View.bottomLayout)
            
            constraints.append(self.buttonLeftView.topLayout == self.button0View.topLayout)
            constraints.append(self.buttonLeftView.bottomLayout == self.button0View.bottomLayout)
            constraints.append(self.buttonLeftView.leadingLayout >= self.contentView.leadingLayout.offset(composable.edgeInsets.left))
            constraints.append(self.buttonLeftView.trailingLayout == self.button7View.trailingLayout)
            
            constraints.append(self.button0View.topLayout == self.button8View.bottomLayout.offset(composable.buttonsSpacing.vertical))
            constraints.append(self.button0View.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom))
            constraints.append(self.button0View.leadingLayout == self.button8View.leadingLayout)
            constraints.append(self.button0View.trailingLayout == self.button8View.trailingLayout)
            
            constraints.append(self.buttonRightView.topLayout == self.button0View.topLayout)
            constraints.append(self.buttonRightView.bottomLayout == self.button0View.bottomLayout)
            constraints.append(self.buttonRightView.leadingLayout == self.button9View.leadingLayout)
            constraints.append(self.buttonRightView.trailingLayout <= self.contentView.trailingLayout.offset(-composable.edgeInsets.right))
            
            self._constraints = constraints
        }
        if self._buttonsSize != composable.buttonsSize {
            self._buttonsSize = composable.buttonsSize
            
            self._button1Constraints = [
                self.button1View.widthLayout == composable.buttonsSize,
                self.button1View.heightLayout == composable.buttonsSize
            ]
            self._button2Constraints = [
                self.button2View.widthLayout == composable.buttonsSize,
                self.button2View.heightLayout == composable.buttonsSize
            ]
            self._button3Constraints = [
                self.button3View.widthLayout == composable.buttonsSize,
                self.button3View.heightLayout == composable.buttonsSize
            ]
            self._button4Constraints = [
                self.button4View.widthLayout == composable.buttonsSize,
                self.button4View.heightLayout == composable.buttonsSize
            ]
            self._button5Constraints = [
                self.button5View.widthLayout == composable.buttonsSize,
                self.button5View.heightLayout == composable.buttonsSize
            ]
            self._button6Constraints = [
                self.button6View.widthLayout == composable.buttonsSize,
                self.button6View.heightLayout == composable.buttonsSize
            ]
            self._button7Constraints = [
                self.button7View.widthLayout == composable.buttonsSize,
                self.button7View.heightLayout == composable.buttonsSize
            ]
            self._button8Constraints = [
                self.button8View.widthLayout == composable.buttonsSize,
                self.button8View.heightLayout == composable.buttonsSize
            ]
            self._button9Constraints = [
                self.button9View.widthLayout == composable.buttonsSize,
                self.button9View.heightLayout == composable.buttonsSize
            ]
            self._button0Constraints = [
                self.button0View.widthLayout == composable.buttonsSize,
                self.button0View.heightLayout == composable.buttonsSize
            ]
            self._buttonLeftConstraints = [
                self.buttonLeftView.widthLayout >= composable.buttonsSize,
                self.buttonLeftView.heightLayout >= composable.buttonsSize
            ]
            self._buttonRightConstraints = [
                self.buttonRightView.widthLayout >= composable.buttonsSize,
                self.buttonRightView.heightLayout >= composable.buttonsSize
            ]
        }
    }
    
    open override func apply(composable: QPincodeComposable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.pincodeView.apply(composable.pincodeStyle)
        if let error = self._error {
            self.errorView.apply(error)
        }
        self.button0View.apply(composable.button0Style)
        self.button1View.apply(composable.button1Style)
        self.button2View.apply(composable.button2Style)
        self.button3View.apply(composable.button3Style)
        self.button4View.apply(composable.button4Style)
        self.button5View.apply(composable.button5Style)
        self.button6View.apply(composable.button6Style)
        self.button7View.apply(composable.button7Style)
        self.button8View.apply(composable.button8Style)
        self.button9View.apply(composable.button9Style)
        if let style = composable.buttonLeftStyle {
            self.buttonLeftView.apply(style)
        }
        if self.pincodeView.isEmpty == true {
            if let style = composable.buttonRightStyle {
                self.buttonRightView.apply(style)
            }
        } else {
            self.buttonRightView.apply(composable.buttonBackspaceStyle)
        }
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.errorView.alpha = (self._error != nil) ? 1 : 0
        self.buttonLeftView.alpha = (composable.buttonLeftStyle != nil) ? 1 : 0
        if (self.pincodeView.isEmpty == false) || (composable.buttonRightStyle != nil) {
            self.buttonRightView.alpha = 1
        } else {
            self.buttonRightView.alpha = 0
        }
    }
    
    public func resetPincode() {
        self.pincodeView.text = ""
        self._updateRightButton()
    }
    
    public func showError(text: String) {
        if let composable = self.composable, let spec = self.spec {
            self._error = composable.styleSheet(error: text)
            self.errorView.apply(self._error!)
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
        self.pincodeView.append(number: number)
        self._updateRightButton()
        if self.pincodeView.isFilled == true {
            if let delegate = self.delegate {
                delegate.pincodeCompositionCompited(self, pin: self.pincodeView.text)
            }
        } else {
            if let delegate = self.delegate {
                delegate.pincodeCompositionUpdated(self, pin: self.pincodeView.text)
            }
        }
    }
    
    private func _updateRightButton() {
        if let composable = self.composable {
            if self.pincodeView.isEmpty == true {
                if let style = composable.buttonRightStyle {
                    self.buttonRightView.apply(style)
                    self.buttonRightView.alpha = 1
                } else {
                    self.buttonRightView.alpha = 0
                }
            } else {
                self.buttonRightView.apply(composable.buttonBackspaceStyle)
                self.buttonRightView.alpha = 1
            }
        } else {
            self.buttonRightView.alpha = 0
        }
    }
    
}
