//
//  Quickly
//

open class QPickerCell< Type: IQPickerRow > : UIView, IQTypedPickerCell {

    open var row: Type?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
    }

    open func set(row: Type) {
        self.row = row
    }

}
