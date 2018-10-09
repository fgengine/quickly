//
//  Quickly
//

public extension Date {
    
    public func isEqual(calendar: Calendar, date: Date, component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: component)
    }

}
