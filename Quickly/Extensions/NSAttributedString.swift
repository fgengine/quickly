//
//  Quickly
//

public extension NSMutableAttributedString {

    func fontInfo(range: NSRange) -> QFontInfo {
        var fontInfo = QFontInfo()
        self.enumerateAttributes(in: range) { (attributes: [NSAttributedString.Key : Any], range: NSRange, stop: UnsafeMutablePointer< ObjCBool >) in
            if let font = attributes[NSAttributedString.Key.font] as? UIFont {
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
