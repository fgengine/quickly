//
//  Quickly
//

public protocol IQApiQuery : class {

    var provider: IQApiProvider { get }
    var createAt: Date { get }

    func start()
    func cancel()

}
