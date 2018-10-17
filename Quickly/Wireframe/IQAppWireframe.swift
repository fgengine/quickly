//
//  Quickly
//

public protocol IQAppWireframe : IQRootWireframe {
    
    var window: QWindow { get }
    
    func launch(_ options: [UIApplication.LaunchOptionsKey : Any]?)
    
}
