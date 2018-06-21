//
//  UIApplication+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension Reactive where Base: UIApplication {
    public func beginBackgroundTask(name: String?, until: Completable) -> Completable {
        return Completable.create { observer in
            let task = self.base.beginBackgroundTask(withName: name) {
                observer(.error(SystemError(message: "Task: \(name ?? "") expired.")))
            }
            
            let work = until.subscribe(observer)
            
            return Disposables.create {
                work.dispose()
                self.base.endBackgroundTask(task)
            }
        }
    }
}
