//
//  Quickly
//

public protocol IQPickerRow : class {

    var section: IQPickerSection? { get }
    var indexPath: IndexPath? { get }

    func bind(_ section: IQPickerSection, _ indexPath: IndexPath)
    func rebind(_ indexPath: IndexPath)
    func unbind()

}
