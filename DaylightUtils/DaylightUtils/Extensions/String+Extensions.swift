//
//  String+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import UIKit

extension String: UtilsCompatible {}

extension Utils where Base == String {
    public func trimmedForLogging(limit: Int = 200) -> String {
        if self.base.count > limit {
            return String(self.base[self.base.startIndex ..< self.base.index(self.base.startIndex, offsetBy: limit)])
        }
        return self.base
    }
    
    public func with(letterSpacing: Double) -> NSAttributedString {
        return NSAttributedString(string: self.base, attributes: [.kern: letterSpacing])
    }
}
