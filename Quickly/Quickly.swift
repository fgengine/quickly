//
//  Quickly
//

@_exported import Foundation
#if os(macOS)
@_exported import AppKit
#elseif os(iOS)
@_exported import UIKit
#endif
#if canImport(CoreGraphics)
import CoreGraphics
#endif
