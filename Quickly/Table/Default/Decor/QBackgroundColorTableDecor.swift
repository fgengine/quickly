//
//  Quickly
//

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

    open override func set(data: Type, spec: IQContainerSpec, animated: Bool) {
        super.set(data: data, spec: spec, animated: animated)
        
        self.backgroundColor = data.backgroundColor
        self.contentView.backgroundColor = data.backgroundColor
    }

}
