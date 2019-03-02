//
//  Logger.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public struct Debug {
    #if DEBUG
    public static var isEnabled = true
    #else
    public static var isEnabled = false
    #endif
    
    public static var isLoggingEnabled = false
    
    public static func log(_ error: Error) {
        if Debug.isEnabled || Debug.isLoggingEnabled {
            debugPrint(error)
        }
    }
    
    public static func log(_ item: @autoclosure () -> Any) {
        if Debug.isEnabled || Debug.isLoggingEnabled {
            debugPrint("\(item())".utils.trimmedForLogging())
        }
    }
    
    public static func crashlyticsLog(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        let filename = URL(string: file)?.lastPathComponent ?? ""
        let prefix = "\(filename):\(line).\(function)"
        
        if Debug.isEnabled {
            crashlyticsInstance?.CLSNSLogv("\(prefix): \(message)")
        } else {
            crashlyticsInstance?.CLSLogv("\(prefix): \(message)")
        }
    }
}
