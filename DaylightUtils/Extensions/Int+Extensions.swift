//
//  Int+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import UIKit

extension Int: UtilsCompatible {}

extension Utils where Base == Int {
    public func hexColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((self.base & 0xFF0000) >> 16)/255.0,
            green: CGFloat((self.base & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(self.base & 0x0000FF)/255.0,
            alpha: alpha
        )
    }
}
