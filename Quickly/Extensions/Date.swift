//
//  Quickly
//

public extension Date {
    
    public func isEqual(calendar: Calendar, date: Date, component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    public func format(_ format: String, calendar: Calendar = Calendar.current, locale: Locale = Locale.current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

}
