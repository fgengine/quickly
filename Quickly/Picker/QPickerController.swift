//
//  Quickly
//

import UIKit

open class QPickerController : NSObject, IQPickerController {

    public weak var delegate: IQPickerControllerDelegate?
    public weak var pickerView: UIPickerView? {
        didSet { self.configure() }
    }
    public var sections: [IQPickerSection] = [] {
        willSet { self._unbindSections() }
        didSet { self._bindSections() }
    }
    public var selectedRows: [IQPickerRow?] {
        get {
            var selectedRows: [IQPickerRow?] = []
            if let pickerView = self.pickerView {
                for section in 0..<pickerView.numberOfComponents {
                    let selectedRow = pickerView.selectedRow(inComponent: section)
                    if selectedRow != -1 {
                        selectedRows.append(self.sections[section].rows[selectedRow])
                    } else {
                        selectedRows.append(nil)
                    }
                }
            } else {
                for _ in 0..<self.sections.count {
                    selectedRows.append(nil)
                }
            }
            return selectedRows
        }
    }
    public private(set) var isBatchUpdating: Bool = false

    open func configure() {
        self.reload()
    }

    public func section(index: Int) -> IQPickerSection {
        return self.sections[index]
    }

    public func index(section: IQPickerSection) -> Int? {
        return section.index
    }

    public func row(indexPath: IndexPath) -> IQPickerRow {
        return self.sections[indexPath.section].rows[indexPath.row]
    }

    public func row(predicate: (IQPickerRow) -> Bool) -> IQPickerRow? {
        for section in self.sections {
            for row in section.rows {
                if predicate(row) {
                    return row
                }
            }
        }
        return nil
    }

    public func indexPath(row: IQPickerRow) -> IndexPath? {
        return row.indexPath
    }

    public func indexPath(predicate: (IQPickerRow) -> Bool) -> IndexPath? {
        for existSection in self.sections {
            for existRow in existSection.rows {
                if predicate(existRow) {
                    return existRow.indexPath
                }
            }
        }
        return nil
    }

    public func reload() {
        guard let pickerView = self.pickerView else { return }
        pickerView.reloadAllComponents()
    }

    public func insertSection(_ sections: [IQPickerSection], index: Int) {
        self.sections.insert(contentsOf: sections, at: index)
        self._rebindSections(from: index, to: self.sections.endIndex)
        if self.isBatchUpdating == false, let pickerView = self.pickerView {
            pickerView.reloadAllComponents()
        }
    }

    public func deleteSection(_ sections: [IQPickerSection]) {
        var indexSet = IndexSet()
        for section in self.sections {
            if let index = self.sections.firstIndex(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            for index in indexSet.reversed() {
                let section = self.sections[index]
                self.sections.remove(at: index)
                section.unbind()
            }
            self._rebindSections(from: indexSet.first!, to: self.sections.endIndex)
        }
        if self.isBatchUpdating == false, let pickerView = self.pickerView {
            pickerView.reloadAllComponents()
        }
    }

    public func performBatchUpdates(_ updates: (() -> Void)) {
        #if DEBUG
            assert(self.isBatchUpdating == false, "Recurcive calling IQPickerController.performBatchUpdates()")
        #endif
        self.isBatchUpdating = true
        updates()
        if let pickerView = self.pickerView {
            pickerView.reloadAllComponents()
        }
        self.isBatchUpdating = false
    }

    public func isSelected(row: IQPickerRow) -> Bool {
        guard
            let pickerView = self.pickerView,
            let indexPath = self.indexPath(row: row)
            else { return false }
        return pickerView.selectedRow(inComponent: indexPath.section) == indexPath.row
    }

    public func select(row: IQPickerRow, animated: Bool) {
        guard
            let pickerView = self.pickerView,
            let indexPath = self.indexPath(row: row)
            else { return }
        pickerView.selectRow(indexPath.row, inComponent: indexPath.section, animated: animated)
    }

}

// MARK: Private

private extension QPickerController {

    func _bindSections() {
        var sectionIndex: Int = 0
        for section in self.sections {
            section.bind(self, sectionIndex)
            sectionIndex += 1
        }
    }

    func _rebindSections(from: Int, to: Int) {
        for index in from..<to {
            self.sections[index].rebind(index)
        }
    }

    func _unbindSections() {
        for section in self.sections {
            section.unbind()
        }
    }

}

// MARK: UIPickerViewDataSource

extension QPickerController : UIPickerViewDataSource {

    @objc
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.sections.count
    }
    
    @objc
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sections[component].rows.count
    }

}

// MARK: UIPickerViewDelegate

extension QPickerController : UIPickerViewDelegate {
    
    @objc
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let section = self.sections[component]
        if(section.size.width > CGFloat.leastNormalMagnitude) {
            return section.size.width
        }
        let pickerWidth = pickerView.bounds.width
        return pickerWidth / CGFloat(self.sections.count)
    }
    
    @objc
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        guard self.sections.count > component else { return 0 }
        let section = self.sections[component]
        return section.size.height
    }
    
    @objc
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let section = self.sections[component]
        guard let cell = section.cellType.dequeue(view) else { return UIView() }
        cell.set(any: section.rows[row])
        return cell
    }
    
    @objc
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate = self.delegate else { return }
        let section = self.sections[component]
        delegate.select(self, section: section, row: section.rows[row])
    }

}
