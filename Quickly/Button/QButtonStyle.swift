//
//  Quickly
//

import UIKit

public class QButtonStyle {

    public weak var parent: QButtonStyle?

    public var color: UIColor? {
        set(value) { self._color = value }
        get {
            if let value: UIColor = self._color { return value }
            if let parent: QButtonStyle = self.parent { return parent.color }
            return nil
        }
    }
    private var _color: UIColor?

    public var borderColor: UIColor? {
        set(value) { self._borderColor = value }
        get {
            if let value: UIColor = self._borderColor { return value }
            if let parent: QButtonStyle = self.parent { return parent.borderColor }
            return nil
        }
    }
    private var _borderColor: UIColor?

    public var borderWidth: CGFloat? {
        set(value) { self._borderWidth = value }
        get {
            if let value: CGFloat = self._borderWidth { return value }
            if let parent: QButtonStyle = self.parent { return parent.borderWidth }
            return nil
        }
    }
    private var _borderWidth: CGFloat?

    public var cornerRadius: CGFloat? {
        set(value) { self._cornerRadius = value }
        get {
            if let value: CGFloat = self._cornerRadius { return value }
            if let parent: QButtonStyle = self.parent { return parent.cornerRadius }
            return nil
        }
    }
    private var _cornerRadius: CGFloat?

    public var imageSource: QImageSource? {
        set(value) { self._imageSource = value }
        get {
            if let value: QImageSource = self._imageSource { return value }
            if let parent: QButtonStyle = self.parent { return parent.imageSource }
            return nil
        }
    }
    private var _imageSource: QImageSource?

    public var text: IQText? {
        set(value) { self._text = value }
        get {
            if let value: IQText = self._text { return value }
            if let parent: QButtonStyle = self.parent { return parent.text }
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
