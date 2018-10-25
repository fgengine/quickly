//
//  Quickly
//

public final class QButtonStyle : IQButtonStyle {

    public weak var parent: IQButtonStyle?

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

    public var shadow: QViewShadow? {
        set(value) { self._shadow = value }
        get {
            if let value = self._shadow { return value }
            if let parent = self.parent { return parent.shadow }
            return nil
        }
    }
    private var _shadow: QViewShadow?

    public var image: QImageViewStyleSheet? {
        set(value) { self._image = value }
        get {
            if let value = self._image { return value }
            if let parent = self.parent { return parent.image }
            return nil
        }
    }
    private var _image: QImageViewStyleSheet?

    public var text: QLabelStyleSheet? {
        set(value) { self._text = value }
        get {
            if let value = self._text { return value }
            if let parent = self.parent { return parent.text }
            return nil
        }
    }
    private var _text: QLabelStyleSheet?

    public init(
        parent: IQButtonStyle? = nil,
        color: UIColor? = nil,
        border: QViewBorder? = nil,
        cornerRadius: QViewCornerRadius? = nil,
        shadow: QViewShadow? = nil,
        image: QImageViewStyleSheet? = nil,
        text: QLabelStyleSheet? = nil
    ) {
        self.parent = parent
        self.color = color
        self.border = border
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.image = image
        self.text = text
    }

}
