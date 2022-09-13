//
//  Quickly
//

import UIKit

open class QPickerView : UIPickerView {

    public var pickerController: IQPickerController? {
        willSet {
            self.delegate = nil
            self.dataSource = nil
            if let pickerController = self.pickerController {
                pickerController.pickerView = nil
            }
        }
        didSet {
            self.delegate = self.pickerController
            self.dataSource = self.pickerController
            if let pickerController = self.pickerController {
                pickerController.pickerView = self
            }
        }
    }

}
