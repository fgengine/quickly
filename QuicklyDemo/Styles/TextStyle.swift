//
//  Quickly
//

import Quickly

struct TextStyle {

    static let base: QTextStyle = {
        let style: QTextStyle = QTextStyle()
        style.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        style.color = UIColor.black
        return style
    }()

}
