//
//  Any+Utils.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

public struct Utils<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol UtilsCompatible {
    associatedtype CompatibleType
    
    static var utils: Utils<CompatibleType>.Type { get }
    
    var utils: Utils<CompatibleType> { get }
}

extension UtilsCompatible {
    public static var utils: Utils<Self>.Type {
        return Utils<Self>.self
    }
    
    public var utils: Utils<Self> {
        return Utils(self)
    }
}

import class Foundation.NSObject

extension NSObject: UtilsCompatible {}
