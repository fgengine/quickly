//
//  Quickly
//

import Quickly

struct TextStyle {

    static let title: QTextStyle = {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        style.color = UIColor.black
        return style
    }()

    static let subtitle: QTextStyle = {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 0.8)
        style.color = UIColor.darkGray
        return style
    }()

    static let link: QTextStyle = {
        let style = QTextStyle()
        style.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        style.color = UIColor.blue
        return style
    }()

}
