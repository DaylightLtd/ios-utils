//
//  Logger.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public struct Debug {
    public static var isLoggingEnabled = false
    
    public static func log(_ error: Error) {
        #if DEBUG
        debugPrint(error)
        #else
        if isLoggingEnabled {
            debugPrint(error)
        }
        #endif
    }
    
    public static func log(_ item: @autoclosure () -> Any) {
        #if DEBUG
        debugPrint("\(item())".utils.trimmedForLogging())
        #else
        if isLoggingEnabled {
            debugPrint("\(item())".utils.trimmedForLogging())
        }
        #endif
    }
    
    public static func crashlyticsLog(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        let filename = URL(string: file)?.lastPathComponent ?? ""
        let prefix = "\(filename):\(line).\(function)"
        
        #if DEBUG
        crashlyticsInstance?.CLSNSLogv("\(prefix): \(message)")
        #else
        crashlyticsInstance?.CLSLogv("\(prefix): \(message)")
        #endif
    }
}
