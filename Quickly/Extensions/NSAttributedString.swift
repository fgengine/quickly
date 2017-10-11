//
//  Quickly
//

public extension NSMutableAttributedString {

    func fontInfo(range: NSRange) -> QFontInfo {
        var fontInfo: QFontInfo = QFontInfo()
        self.enumerateAttributes(in: range) { (attributes: [NSAttributedStringKey : Any], range: NSRange, stop: UnsafeMutablePointer< ObjCBool >) in
            if let font: QPlatformFont = attributes[NSAttributedStringKey.font] as? QPlatformFont {
                fontInfo.height = max(fontInfo.height, font.pointSize)
                fontInfo.ascender = max(fontInfo.ascender, font.ascender)
                fontInfo.descender = max(fontInfo.descender, font.descender)
                fontInfo.capHeight = max(fontInfo.capHeight, font.capHeight)
                fontInfo.xHeight = max(fontInfo.xHeight, font.xHeight)
            }
        }
        return fontInfo
    }

    func deleteAllCharacters() {
        self.deleteCharacters(in: NSRange(location: 0, length: self.length))
    }

}
