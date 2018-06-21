//
//  SystemError.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public struct SystemError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    let file: String
    let line: UInt
    let function: String
    let message: String
    
    public init(message: String = "", file: String = #file, line: UInt = #line, function: String = #function) {
        self.file = file
        self.line = line
        self.function = function
        self.message = message
    }
}

extension SystemError {
    public var description: String {
        return "'\(self.message)' [\(file):\(line)] @ \(function)"
    }
    
    public var debugDescription: String {
        return description
    }
}
