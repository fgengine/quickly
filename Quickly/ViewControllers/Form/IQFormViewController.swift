//
//  Quickly
//

import UIKit

// MARK: IQFormViewController

public protocol IQFormViewController : IQViewController {
    
    var fields: [IQFormViewControllerField] { set get }
    var currentField: IQFormViewControllerField? { set get }
    var toolbarView: QDisplayView { get }
    var toolbarEdgeInsets: UIEdgeInsets { set get }
    var toolbarProgressTitleView: QLabel { get }
    var toolbarProgressView: QProgressViewType { get }
    var toolbarProgressHeight: CGFloat { set get }
    var toolbarProgressSpacing: CGFloat { set get }
    var toolbarPrevView: QButton { get }
    var toolbarPrevSpacing: CGFloat { set get }
    var toolbarNextView: QButton { get }
    var toolbarNextSpacing: CGFloat { set get }
    var toolbarDoneView: QButton { get }
    var toolbarDoneSpacing: CGFloat { set get }
    
    func toolbarProgressTitleStyleSheet(current: Int, total: Int) -> QLabelStyleSheet
    
    func didPressedDone()
    
    func set(fields: [IQFormViewControllerField], currentField: IQFormViewControllerField?, animated: Bool, completion: (() -> Swift.Void)?)
    func set(currentField: IQFormViewControllerField?, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarEdgeInsets: UIEdgeInsets, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarProgressHeight: CGFloat, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarProgressSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarPrevSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarNextSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?)
    func set(toolbarDoneSpacing: CGFloat, animated: Bool, completion: (() -> Swift.Void)?)
    
}

// MARK: IQFormViewControllerFieldDelegate

public protocol IQFormViewControllerFieldDelegate : AnyObject {
    
    func `continue`(field: IQFormViewControllerField)
    
}

// MARK: IQFormViewControllerField

public protocol IQFormViewControllerField : AnyObject {
    
    var delegate: IQFormViewControllerFieldDelegate? { set get }
    var view: QDisplayView { get }
    var isValid: Bool { get }
    
    func beginEditing()
    func endEditing()
    
    func showError()
    
}
