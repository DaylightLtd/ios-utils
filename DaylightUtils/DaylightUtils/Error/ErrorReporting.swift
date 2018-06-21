//
//  ErrorReporting.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public protocol CrashlyticsService {
    func recordError(_ error: Error)
    func recordError(_ error: Error, withAdditionalUserInfo userInfo: [String: Any]?)
    func setUserIdentifier(_ identifier: String?)
    func CLSLogv(_ message: String)
    func CLSNSLogv(_ message: String)
}

public var crashlyticsInstance: CrashlyticsService? = nil

struct StringError: Error {
    let message: String
}

public func fatalErrorInDebugOrReportError<T>(default: T, file: String = #file, function: String = #function, line: Int = #line, action: () throws -> T) -> T {
    do {
        return try action()
    } catch let error {
        #if DEBUG
        fatalError("Error while executing: \(error)")
        #else
        reportError(error, file: file, function: function, line: line)
        return `default`
        #endif
    }
}

public func fatalErrorInDebugOrReportError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    print("\(file):\(line)")
    fatalError(message)
    #else
    reportError(message, file: file, function: function, line: line)
    #endif
}

public func fatalErrorInDebugOrReportError(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    print("\(file):\(line)")
    fatalError(error.localizedDescription)
    #else
    reportError(error, file: file, function: function, line: line)
    #endif
}

public func reportError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    crashlyticsInstance?.recordError(StringError(message: message), withAdditionalUserInfo: [
        "file": file,
        "line": line,
        "function": function,
        "message": message
        ])
    Debug.log("Error encountered in \(file):\(function):\(line): \(message)")
}

public func reportError(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
    crashlyticsInstance?.recordError(error, withAdditionalUserInfo: [
        "file": file,
        "line": line,
        "function": function,
        "message": error.localizedDescription
        ])
    Debug.log("Error encountered in \(file):\(function):\(line): \(error)")
}
