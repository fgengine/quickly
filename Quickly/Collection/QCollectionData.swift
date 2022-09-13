//
//  Quickly
//

import UIKit

open class QCollectionData : IQCollectionData {

    public private(set) weak var section: IQCollectionSection? = nil

    public init() {
    }

    public func bind(_ section: IQCollectionSection) {
        self.section = section
    }

    public func unbind() {
        self.section = nil
    }

}
