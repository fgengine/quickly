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

open class QBackgroundColorTableDecor< DataType : QBackgroundColorTableData > : QTableDecor< DataType > {

    open override func prepare(data: DataType, spec: IQContainerSpec, animated: Bool) {
        super.prepare(data: data, spec: spec, animated: animated)
        
        self.contentView.backgroundColor = data.backgroundColor
    }

}
