//
//  Quickly
//

import Foundation

public extension NSMutableAttributedString {

    func deleteAllCharacters() {
        self.deleteCharacters(in: NSRange(location: 0, length: self.length))
    }

}
