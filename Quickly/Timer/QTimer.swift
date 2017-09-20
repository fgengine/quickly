//
//  Quickly
//

import Foundation

public class QTimer: NSObject {

    public typealias Closure = (_ timer: QTimer) -> Void

    public private(set) var isDelaying: Bool = false
    public private(set) var isStarted: Bool = false
    public private(set) var isPaused: Bool = false
    public var interval: TimeInterval
    public var delay: TimeInterval
    public var repeating: UInt
    public private(set) var duration: TimeInterval = 0
    public private(set) var elapsed: TimeInterval = 0
    public private(set) var repeated: UInt = 0

    public var onStarted: Closure?
    public var onRepeat: Closure?
    public var onFinished: Closure?
    public var onStoped: Closure?
    public var onPaused: Closure?
    public var onResumed: Closure?

    private var startDelayDate: Date?
    private var startDate: Date?
    private var pauseDate: Date?
    private var timer: Timer?

    public init(interval: TimeInterval, delay: TimeInterval = 0, repeating: UInt = 0) {
        self.interval = interval
        self.delay = delay
        self.repeating = repeating
    }

    public func start() {
        if self.isStarted == false {
            self.isStarted = true
            self.isPaused = false
            if self.delay > TimeInterval.ulpOfOne {
                self.startDate = Date() + self.delay
                self.isDelaying = true
            } else {
                self.startDate = Date() + self.interval
                self.isDelaying = false
            }
            self.pauseDate = nil
            self.repeated = 0
            self.timer = Timer(
                fireAt: self.startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self.handler(_:)),
                userInfo: nil,
                repeats: (self.isDelaying == true) || (self.repeating != 0)
            )
            if self.isDelaying == false {
                if let closure: Closure = self.onStarted {
                    closure(self)
                }
            }
            RunLoop.main.add(self.timer!, forMode: .commonModes)
        }
    }

    public func stop() {
        if self.isStarted == true {
            self.isDelaying = false
            self.isStarted = false
            self.isPaused = false
            self.startDate = nil
            self.pauseDate = nil
            self.repeated = 0
            if let timer: Timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            if let closure: Closure = self.onStoped {
                closure(self)
            }
        }
    }

    public func pause() {
        if (self.isStarted == true) && (self.isPaused == false) {
            self.isPaused = true
            self.pauseDate = Date()
            if let timer: Timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            if let closure: Closure = self.onPaused {
                closure(self)
            }
        }
    }

    public func resume() {
        if (self.isStarted == true) && (self.isPaused == true) {
            self.isPaused = false

            self.startDate = self.startDate! + (Date().timeIntervalSince1970 - self.pauseDate!.timeIntervalSince1970)
            self.pauseDate = nil;
            self.timer = Timer(
                fireAt: self.startDate!,
                interval: self.interval,
                target: self,
                selector: #selector(self.handler(_:)),
                userInfo: nil,
                repeats: (self.repeating != 0)
            )
            if let closure: Closure = self.onResumed {
                closure(self)
            }
            RunLoop.main.add(self.timer!, forMode: .commonModes)
        }
    }

    public func restart() {
        if self.isStarted == true {
            self.stop()
            self.start()
        }
    }

    @IBAction private func handler(_ sender: Any) {
        if self.isDelaying == true {
            self.isDelaying = false
            if let closure: Closure = self.onStarted {
                closure(self)
            }
        } else {
            var finished: Bool = false
            self.repeated += 1
            if self.repeating == UInt.max {
                if let closure: Closure = self.onRepeat {
                    closure(self)
                }
            } else if self.repeated != 0 {
                if let closure: Closure = self.onRepeat {
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
                if let timer: Timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                }
                if let closure: Closure = self.onFinished {
                    closure(self)
                }
            }
        }
    }

}
