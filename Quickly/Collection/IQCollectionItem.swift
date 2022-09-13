//
//  Quickly
//

import UIKit

public protocol IQCollectionItem : AnyObject {

    var section: IQCollectionSection? { get }
    var indexPath: IndexPath? { get }
    var canSelect: Bool { get }
    var canDeselect: Bool { get }
    var canMove: Bool { get }

    func bind(_ section: IQCollectionSection, _ indexPath: IndexPath)
    func unbind()

}
