//
//  Quickly
//

import Foundation

public protocol IQStringFormatter {

    func format(_ string: String) -> String
    func unformat(_ string: String) -> String

}
