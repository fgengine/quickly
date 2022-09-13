//
//  Quickly
//

import UIKit

public protocol IQPagesView : IQView {
    
    var numberOfPages: UInt { set get }
    var currentPage: UInt { set get }
    var currentProgress: CGFloat { set get }
    var hidesForSinglePage: Bool { set get }

}

public typealias QPagesViewType = UIView & IQPagesView
