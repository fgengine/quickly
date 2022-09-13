//
//  Quickly
//

import UIKit

open class QBackgroundColorTableData : QTableData {

    public var backgroundColor: UIColor?

    public init(
        backgroundColor: UIColor? = nil
    ) {
        self.backgroundColor = backgroundColor
        super.init()
    }

}

open class QBackgroundColorTableDecor< Type: QBackgroundColorTableData > : QTableDecor< Type > {

    open override func prepare(data: Type, spec: IQContainerSpec, animated: Bool) {
        super.prepare(data: data, spec: spec, animated: animated)
        
        self.contentView.backgroundColor = data.backgroundColor
    }

}
