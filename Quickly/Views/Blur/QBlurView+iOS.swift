//
//  Quickly
//

#if os(iOS)

    open class QBlurView : UIVisualEffectView, IQView {

        private var blurEffect: UIBlurEffect!

        public var grayscaleTintLevel: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.grayscaleTintLevel) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.grayscaleTintLevel, empty: 0) }
        }
        public var grayscaleTintAlpha: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.grayscaleTintAlpha) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.grayscaleTintAlpha, empty: 1) }
        }
        public var lightenGrayscaleWithSourceOver: Bool {
            set(value) { self.setBool(value, blurKeyPath: BlurKeyPath.lightenGrayscaleWithSourceOver) }
            get { return self.getBool(blurKeyPath: BlurKeyPath.lightenGrayscaleWithSourceOver, empty: false) }
        }
        public var colorTint: QPlatformColor? {
            set(value) { self.setUIColor(value, blurKeyPath: BlurKeyPath.colorTint) }
            get { return self.getUIColor(blurKeyPath: BlurKeyPath.colorTint, empty: nil) }
        }
        public var colorTintAlpha: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.colorTintAlpha) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.colorTintAlpha, empty: 0) }
        }
        public var colorBurnTintLevel: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.colorBurnTintLevel) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.colorBurnTintLevel, empty: 0) }
        }
        public var colorBurnTintAlpha: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.colorBurnTintAlpha) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.colorBurnTintAlpha, empty: 1) }
        }
        public var darkeningTintAlpha: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintAlpha) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintAlpha, empty: 1) }
        }
        public var darkeningTintHue: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintHue) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintHue, empty: 0) }
        }
        public var darkeningTintSaturation: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.darkeningTintSaturation) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.darkeningTintSaturation, empty: 0) }
        }
        public var darkenWithSourceOver: Bool {
            set(value) { self.setBool(value, blurKeyPath: BlurKeyPath.darkenWithSourceOver) }
            get { return self.getBool(blurKeyPath: BlurKeyPath.darkenWithSourceOver, empty: false) }
        }
        public var blurRadius: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.blurRadius) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.blurRadius, empty: 0) }
        }
        public var saturationDeltaFactor: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.saturationDeltaFactor) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.saturationDeltaFactor, empty: 0) }
        }
        public var scale: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.scale) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.scale, empty: 0) }
        }
        public var zoom: CGFloat {
            set(value) { self.setCGFloat(value, blurKeyPath: BlurKeyPath.zoom) }
            get { return self.getCGFloat(blurKeyPath: BlurKeyPath.zoom, empty: 0) }
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
            self.blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
            self.scale = 1.0
        }

        private func set(_ value: Any?, blurKeyPath: String) {
            self.blurEffect.setValue(value, forKeyPath: blurKeyPath)
            self.effect = self.blurEffect
        }

        private func get(blurKeyPath: String) -> Any? {
            return self.blurEffect.value(forKeyPath: blurKeyPath)
        }

        private func setNumber(_ value: NSNumber, blurKeyPath: String) {
            self.set(value, blurKeyPath: blurKeyPath)
        }

        private func getNumber(blurKeyPath: String, empty: NSNumber) -> NSNumber {
            guard let number = self.get(blurKeyPath: blurKeyPath) as? NSNumber else { return empty }
            return number
        }

        private func setBool(_ value: Bool, blurKeyPath: String) {
            self.setNumber(NSNumber(value: value), blurKeyPath: blurKeyPath)
        }

        private func getBool(blurKeyPath: String, empty: Bool) -> Bool {
            return self.getNumber(blurKeyPath: blurKeyPath, empty: NSNumber(value: empty)).boolValue
        }

        private func setCGFloat(_ value: CGFloat, blurKeyPath: String) {
            self.setNumber(NSNumber(value: Float(value)), blurKeyPath: blurKeyPath)
        }

        private func getCGFloat(blurKeyPath: String, empty: CGFloat) -> CGFloat {
            return CGFloat(self.getNumber(blurKeyPath: blurKeyPath, empty: NSNumber(value: Float(empty))).floatValue)
        }

        private func setUIColor(_ value: UIColor?, blurKeyPath: String) {
            self.set(value, blurKeyPath: blurKeyPath)
        }

        private func getUIColor(blurKeyPath: String, empty: UIColor?) -> UIColor? {
            guard let color = self.get(blurKeyPath: blurKeyPath) as? UIColor else { return empty }
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

#endif

