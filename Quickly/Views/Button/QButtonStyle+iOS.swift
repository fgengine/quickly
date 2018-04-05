//
//  Quickly
//

#if os(iOS)

    public class QButtonStyle {

        public weak var parent: QButtonStyle?

        public var color: UIColor? {
            set(value) { self._color = value }
            get {
                if let value = self._color { return value }
                if let parent = self.parent { return parent.color }
                return nil
            }
        }
        private var _color: UIColor?

        public var border: QViewBorder? {
            set(value) { self._border = value }
            get {
                if let value = self._border { return value }
                if let parent = self.parent { return parent.border }
                return nil
            }
        }
        private var _border: QViewBorder?

        public var cornerRadius: QViewCornerRadius? {
            set(value) { self._cornerRadius = value }
            get {
                if let value = self._cornerRadius { return value }
                if let parent = self.parent { return parent.cornerRadius }
                return nil
            }
        }
        private var _cornerRadius: QViewCornerRadius?

        public var imageSource: QImageSource? {
            set(value) { self._imageSource = value }
            get {
                if let value = self._imageSource { return value }
                if let parent = self.parent { return parent.imageSource }
                return nil
            }
        }
        private var _imageSource: QImageSource?

        public var text: IQText? {
            set(value) { self._text = value }
            get {
                if let value = self._text { return value }
                if let parent = self.parent { return parent.text }
                return nil
            }
        }
        private var _text: IQText?

        public init() {
        }

        public init(parent: QButtonStyle) {
            self.parent = parent
        }

    }

#endif
