//
//  Quickly
//

public extension NSError {

    func isUrlError() -> Bool {
        return (self.domain == NSURLErrorDomain)
    }

    func isUrlErrorCancelled() -> Bool {
        return (self.domain == NSURLErrorDomain) && (self.code == NSURLErrorCancelled)
    }

}
