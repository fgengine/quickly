//
//  Quickly
//

import UIKit

open class QCollectionView: UICollectionView {

    public var collectionController: IQCollectionController? {
        willSet {
            self.delegate = nil
            self.dataSource = nil
            if let collectionController: IQCollectionController = self.collectionController {
                collectionController.collectionView = nil
            }
        }
        didSet {
            self.delegate = self.collectionController
            self.dataSource = self.collectionController
            if let collectionController: IQCollectionController = self.collectionController {
                collectionController.collectionView = self
            }
        }
    }

}
