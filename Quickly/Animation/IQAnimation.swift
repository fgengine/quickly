//
//  Quickly
//

public protocol IQFixedAnimation : class {

    func update(animated: Bool, complete: @escaping (_ completed: Bool) -> Void)

}

public protocol IQInteractiveAnimation : class {

    var canFinish: Bool { get }

    func update(position: CGPoint, velocity: CGPoint)
    func cancel(_ complete: @escaping (_ completed: Bool) -> Void)
    func finish(_ complete: @escaping (_ completed: Bool) -> Void)

}
