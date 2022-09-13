//
//  Quickly
//

import UIKit

public final class QTimer : NSObject {

    public typealias Closure = (_ timer: QTimer) -> Void

    public var interval: TimeInterval
    public var delay: TimeInterval
    public var repeating: UInt
    public private(set) var isDelaying: Bool
    public private(set) var isStarted: Bool
    public private(set) var isPaused: Bool
    public private(set) var repeated: UInt

    public var onStarted: Closure?
    public var onRepeat: Closure?
    public var onFinished: Closure?
    public var onStoped: Closure?
    public var onPaused: Closure?
    public var onResumed: Closure?

    private var _startDelayDate: Date?
    private var _startDate: Date?
    private var _pauseDate: Date?
    private var _timer: Timer?

    public init(interval: TimeInterval, delay: TimeInterval, repeating: UInt) {
        self.interval = interval
        self.delay = delay
        self.repeating = repeating
        self.isDelaying = false
        self.isStarted = false
        self.isPaused = false
        self.repeated = 0
        super.init()
        self._subsribe()
    }

    public convenience init(
        interval: TimeInterval,
        onFinished: @escaping Closure
    ) {
        self.init(interval: interval, delay: 0, repeating: 0)
        self.onFinished = onFinished
    }

    public convenience init(
        interval: TimeInterval,
        repeating: UInt,
        onRepeat: @escaping Closure,
        onFinished: @escaping Closure
    ) {
        self.init(interval: interval, delay: 0, repeating: repeating)
        self.onRepeat = onRepeat
        self.onFinished = onFinished
    }
    
    deinit {
        self._unsubsribe()
    }

    public func start() {
        if self.isStarted == false {
            self.isStarted = true
            self.isPaused = false
            if self.delay > TimeInterval.ulpOfOne {
                self._startDate = Date() + self.delay
                self.isDelaying = true
            } else {
                self._startDate = Date() + self.interval
                self.isDelaying = false
            }
            self._pauseDate = nil
            self.repeated = 0
            self._timer = Timer(
                fireAt: self._startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self._handler(_:)),
                userInfo: nil,
                repeats: (self.isDelaying == true) || (self.repeating != 0)
            )
            if self.isDelaying == false {
                self.onStarted?(self)
            }
            RunLoop.main.add(self._timer!, forMode: RunLoop.Mode.common)
        }
    }

    public func stop() {
        if self.isStarted == true {
            self.isDelaying = false
            self.isStarted = false
            self.isPaused = false
            self._startDate = nil
            self._pauseDate = nil
            self.repeated = 0
            if let timer = self._timer {
                timer.invalidate()
                self._timer = nil
            }
            self.onStoped?(self)
        }
    }

    public func pause() {
        if (self.isStarted == true) && (self.isPaused == false) {
            self.isPaused = true
            self._pauseDate = Date()
            if let timer = self._timer {
                timer.invalidate()
                self._timer = nil
            }
            self.onPaused?(self)
        }
    }

    public func resume() {
        if (self.isStarted == true) && (self.isPaused == true) {
            self.isPaused = false
            self._startDate = self._startDate! + (Date().timeIntervalSince1970 - self._pauseDate!.timeIntervalSince1970)
            self._pauseDate = nil;
            self._timer = Timer(
                fireAt: self._startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self._handler(_:)),
                userInfo: nil,
                repeats: (self.repeating != 0)
            )
            self.onResumed?(self)
            RunLoop.main.add(self._timer!, forMode: RunLoop.Mode.common)
        }
    }

    public func restart() {
        self.stop()
        self.start()
    }
    
}

private extension QTimer {
    
    func _subsribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self._didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self._willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func _unsubsribe() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc
    func _didEnterBackground(_ notification: Notification) {
        self.pause()
    }
    
    @objc
    func _willEnterForeground(_ notification: Notification) {
        self.resume()
    }

    @objc
    func _handler(_ sender: Any) {
        if self.isDelaying == true {
            self.isDelaying = false
            if let closure = self.onStarted {
                closure(self)
            }
        } else {
            var finished = false
            self.repeated += 1
            if self.repeating == UInt.max {
                if let closure = self.onRepeat {
                    closure(self)
                }
            } else if self.repeated != 0 {
                if let closure = self.onRepeat {
                    closure(self)
                }
                if self.repeated >= self.repeating {
                    finished = true
                }
            } else {
                finished = true
            }
            if finished == true {
                self.isStarted = false
                self.isPaused = false
                if let timer = self._timer {
                    timer.invalidate()
                    self._timer = nil
                }
                if let closure = self.onFinished {
                    closure(self)
                }
            }
        }
    }

}
