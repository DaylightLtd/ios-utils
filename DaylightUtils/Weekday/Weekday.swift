//
//  Weekday.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public struct Weekday: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(date: Date) {
        let calendarWeekday = Calendar.current.component(.weekday, from: date)
        self.rawValue = 1 << (calendarWeekday - 1)
    }
    
    public static let sunday = Weekday(rawValue: 1 << 0)
    public static let monday = Weekday(rawValue: 1 << 1)
    public static let tuesday = Weekday(rawValue: 1 << 2)
    public static let wednesday = Weekday(rawValue: 1 << 3)
    public static let thursday = Weekday(rawValue: 1 << 4)
    public static let friday = Weekday(rawValue: 1 << 5)
    public static let saturday = Weekday(rawValue: 1 << 6)
    
    public static let none: Weekday = []
    public static let weekdays: Weekday = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: Weekday = [.saturday, .sunday]
    public static let all: Weekday = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    public var weekdayInCalendar: Int {
        return Int(log2(Double(self.rawValue)))
    }
    
    public var symbol: String {
        guard self.weekdayInCalendar < Calendar.current.weekdaySymbols.count else { return "Unknown" }
        return Calendar.current.weekdaySymbols[self.weekdayInCalendar]
    }
    
    public var shortSymbol: String {
        guard self.weekdayInCalendar < Calendar.current.shortWeekdaySymbols.count else { return "Unknown" }
        return Calendar.current.shortWeekdaySymbols[self.weekdayInCalendar]
    }
    
    public var veryShortSymbol: String {
        guard self.weekdayInCalendar < Calendar.current.veryShortWeekdaySymbols.count else { return "Unknown" }
        return Calendar.current.veryShortWeekdaySymbols[self.weekdayInCalendar]
    }
}
