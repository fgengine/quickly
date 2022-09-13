//
//  Quickly
//

import UIKit

public protocol IQCollectionData : AnyObject {

    var section: IQCollectionSection? { get }

    func bind(_ section: IQCollectionSection)
    func unbind()

}
