//
//  Quickly
//

open class QBlurView : UIVisualEffectView, IQView {

    private var _blurEffect: UIBlurEffect!

    public var grayscaleTintLevel: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.grayscaleTintLevel) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.grayscaleTintLevel, empty: 0) }
    }
    public var grayscaleTintAlpha: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.grayscaleTintAlpha) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.grayscaleTintAlpha, empty: 1) }
    }
    public var lightenGrayscaleWithSourceOver: Bool {
        set(value) { self._setBool(value, blurKeyPath: BlurKeyPath.lightenGrayscaleWithSourceOver) }
        get { return self._getBool(blurKeyPath: BlurKeyPath.lightenGrayscaleWithSourceOver, empty: false) }
    }
    public var colorTint: UIColor? {
        set(value) { self._setUIColor(value, blurKeyPath: BlurKeyPath.colorTint) }
        get { return self._getUIColor(blurKeyPath: BlurKeyPath.colorTint, empty: nil) }
    }
    public var colorTintAlpha: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.colorTintAlpha) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.colorTintAlpha, empty: 0) }
    }
    public var colorBurnTintLevel: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.colorBurnTintLevel) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.colorBurnTintLevel, empty: 0) }
    }
    public var colorBurnTintAlpha: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.colorBurnTintAlpha) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.colorBurnTintAlpha, empty: 1) }
    }
    public var darkeningTintAlpha: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintAlpha) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintAlpha, empty: 1) }
    }
    public var darkeningTintHue: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintHue) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintHue, empty: 0) }
    }
    public var darkeningTintSaturation: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintSaturation) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintSaturation, empty: 0) }
    }
    public var darkenWithSourceOver: Bool {
        set(value) { self._setBool(value, blurKeyPath: BlurKeyPath.darkenWithSourceOver) }
        get { return self._getBool(blurKeyPath: BlurKeyPath.darkenWithSourceOver, empty: false) }
    }
    public var blurRadius: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.blurRadius) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.blurRadius, empty: 0) }
    }
    public var saturationDeltaFactor: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.saturationDeltaFactor) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.saturationDeltaFactor, empty: 0) }
    }
    public var scale: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.scale) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.scale, empty: 0) }
    }
    public var zoom: CGFloat {
        set(value) { self._setCGFloat(value, blurKeyPath: BlurKeyPath.zoom) }
        get { return self._getCGFloat(blurKeyPath: BlurKeyPath.zoom, empty: 0) }
    }
    
    public required init() {
        super.init(effect: nil)
        self.setup()
    }

    public init(blurRadius: CGFloat) {
        super.init(effect: nil)
        self.setup()
        self.blurRadius = blurRadius
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
        self._blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
        self.scale = 1.0
    }

    private func _set(_ value: Any?, blurKeyPath: String) {
        self._blurEffect.setValue(value, forKeyPath: blurKeyPath)
        self.effect = self._blurEffect
    }

    private func _get(blurKeyPath: String) -> Any? {
        return self._blurEffect.value(forKeyPath: blurKeyPath)
    }

    private func _setNumber(_ value: NSNumber, blurKeyPath: String) {
        self._set(value, blurKeyPath: blurKeyPath)
    }

    private func _getNumber(blurKeyPath: String, empty: NSNumber) -> NSNumber {
        guard let number = self._get(blurKeyPath: blurKeyPath) as? NSNumber else { return empty }
        return number
    }

    private func _setBool(_ value: Bool, blurKeyPath: String) {
        self._setNumber(NSNumber(value: value), blurKeyPath: blurKeyPath)
    }

    private func _getBool(blurKeyPath: String, empty: Bool) -> Bool {
        return self._getNumber(blurKeyPath: blurKeyPath, empty: NSNumber(value: empty)).boolValue
    }

    private func _setCGFloat(_ value: CGFloat, blurKeyPath: String) {
        self._setNumber(NSNumber(value: Float(value)), blurKeyPath: blurKeyPath)
    }

    private func _getCGFloat(blurKeyPath: String, empty: CGFloat) -> CGFloat {
        return CGFloat(self._getNumber(blurKeyPath: blurKeyPath, empty: NSNumber(value: Float(empty))).floatValue)
    }

    private func _setUIColor(_ value: UIColor?, blurKeyPath: String) {
        self._set(value, blurKeyPath: blurKeyPath)
    }

    private func _getUIColor(blurKeyPath: String, empty: UIColor?) -> UIColor? {
        guard let color = self._get(blurKeyPath: blurKeyPath) as? UIColor else { return empty }
        return color
    }

    private struct BlurKeyPath {

        static let grayscaleTintLevel: String = "grayscaleTintLevel"
        static let grayscaleTintAlpha: String = "grayscaleTintAlpha"
        static let lightenGrayscaleWithSourceOver: String = "lightenGrayscaleWithSourceOver"
        static let colorTint: String = "colorTint"
        static let colorTintAlpha: String = "colorTintAlpha"
        static let colorBurnTintLevel: String = "colorBurnTintLevel"
        static let colorBurnTintAlpha: String = "colorBurnTintAlpha"
        static let darkeningTintAlpha: String = "darkeningTintAlpha"
        static let darkeningTintHue: String = "darkeningTintHue"
        static let darkeningTintSaturation: String = "darkeningTintSaturation"
        static let darkenWithSourceOver: String = "darkenWithSourceOver"
        static let blurRadius: String = "blurRadius"
        static let saturationDeltaFactor: String = "saturationDeltaFactor"
        static let scale: String = "scale"
        static let zoom: String = "zoom"

    }

}
