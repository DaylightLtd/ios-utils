//
//  NotificationCenter+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension Reactive where Base: NotificationCenter {
    public var keyboardHeight: Observable<CGFloat> {
        return Observable.deferred {
            let keyboardWillShow = self
                .notification(UIResponder.keyboardWillShowNotification)
                .map { (($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? CGRect.zero).height }
            
            let keyboardWillHide = NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
            
            return Observable.merge(keyboardWillShow, keyboardWillHide)
        }
    }
}
