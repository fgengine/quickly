//
//  Quickly
//

import UIKit

public class QText: IQText {

    public private(set) var attributed: NSAttributedString

    public init(_ text: String) {
        self.attributed = NSAttributedString(string: text)
    }

    public init(_ attributed: NSAttributedString) {
        self.attributed = attributed
    }

}
