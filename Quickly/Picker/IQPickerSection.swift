//
//  Quickly
//

import UIKit

public protocol IQPickerSection : AnyObject {

    var controller: IQPickerController? { get }
    var cellType: (UIView & IQPickerCell).Type { get }
    var size: CGSize { get }
    var index: Int? { get }
    var rows: [IQPickerRow] { set get }

    func bind(_ controller: IQPickerController, _ index: Int)
    func rebind(_ index: Int)
    func unbind()

    func prependRow(_ row: IQPickerRow)
    func prependRow(_ rows: [IQPickerRow])
    func appendRow(_ row: IQPickerRow)
    func appendRow(_ rows: [IQPickerRow])
    func insertRow(_ row: IQPickerRow, index: Int)
    func insertRow(_ rows: [IQPickerRow], index: Int)
    func deleteRow(_ row: IQPickerRow)
    func deleteRow(_ rows: [IQPickerRow])

}

public extension IQPickerSection {

    func prependRow(_ row: IQPickerRow) {
        self.insertRow([ row ], index: self.rows.startIndex)
    }

    func prependRow(_ rows: [IQPickerRow]) {
        self.insertRow(rows, index: self.rows.startIndex)
    }

    func appendRow(_ row: IQPickerRow) {
        self.insertRow([ row ], index: self.rows.endIndex)
    }

    func appendRow(_ rows: [IQPickerRow]) {
        self.insertRow(rows, index: self.rows.endIndex)
    }

    func insertRow(_ row: IQPickerRow, index: Int) {
        self.insertRow([ row ], index: index)
    }

    func deleteRow(_ row: IQPickerRow) {
        self.deleteRow([ row ])
    }

}
