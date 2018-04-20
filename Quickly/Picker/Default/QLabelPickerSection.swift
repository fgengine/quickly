//
//  Quickly
//

open class QLabelPickerSection : QPickerSection {

    public init(size: CGSize, rows: [IQPickerRow]) {
        super.init(cellType: QLabelPickerCell.self, size: size, rows: rows)
    }

    public convenience init(height: CGFloat, rows: [IQPickerRow]) {
        self.init(size: CGSize(width: 0, height: height), rows: rows)
    }

}
