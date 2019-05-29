//
//  ParsingError.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation

public enum ParsingError: Error {
    case instance(file: String, function: String, line: Int)
}

public extension ParsingError {
    static func makeParsingError(file: String = #file, function: String = #function, line: Int = #line) -> ParsingError {
        return .instance(file: file, function: function, line: line)
    }
}

public extension Optional {
    func unwrapOrThrow(file: String = #file, function: String = #function, line: Int = #line) throws -> Wrapped {
        guard case .some(let value) = self else {
            throw ParsingError.makeParsingError(file: file, function: function, line: line)
        }
        return value
    }
}
