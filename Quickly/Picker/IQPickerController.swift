//
//  Quickly
//

public protocol IQPickerControllerDelegate : class {

    func select(_ controller: IQPickerController, section: IQPickerSection, row: IQPickerRow)

}

public protocol IQPickerController : UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: IQPickerControllerDelegate? { set get }
    var pickerView: UIPickerView? { set get }

    var sections: [IQPickerSection] { set get }
    var selectedRows: [IQPickerRow?] { get }
    var isBatchUpdating: Bool { get }

    func configure()

    func section(index: Int) -> IQPickerSection
    func index(section: IQPickerSection) -> Int?

    func row(indexPath: IndexPath) -> IQPickerRow
    func row(predicate: (IQPickerRow) -> Bool) -> IQPickerRow?

    func indexPath(row: IQPickerRow) -> IndexPath?
    func indexPath(predicate: (IQPickerRow) -> Bool) -> IndexPath?

    func reload()

    func prependSection(_ section: IQPickerSection)
    func prependSection(_ sections: [IQPickerSection])
    func appendSection(_ section: IQPickerSection)
    func appendSection(_ sections: [IQPickerSection])
    func insertSection(_ section: IQPickerSection, index: Int)
    func insertSection(_ sections: [IQPickerSection], index: Int)
    func deleteSection(_ section: IQPickerSection)
    func deleteSection(_ sections: [IQPickerSection])

    func performBatchUpdates(_ updates: (() -> Void))

    func isSelected(row: IQPickerRow) -> Bool
    func select(row: IQPickerRow, animated: Bool)

}

public extension IQPickerController {

    public func prependSection(_ section: IQPickerSection) {
        self.insertSection([ section ], index: self.sections.startIndex)
    }

    public func prependSection(_ sections: [IQPickerSection]) {
        self.insertSection(sections, index: self.sections.startIndex)
    }

    public func appendSection(_ section: IQPickerSection) {
        self.insertSection([ section ], index: self.sections.endIndex)
    }

    public func appendSection(_ sections: [IQPickerSection]) {
        self.insertSection(sections, index: self.sections.endIndex)
    }

    public func insertSection(_ section: IQPickerSection, index: Int) {
        self.insertSection([ section ], index: index)
    }

    public func deleteSection(_ section: IQPickerSection) {
        self.deleteSection([ section ])
    }

}
