//
//  UIViewController+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension Utils where Base: UIViewController {
    public static var xibName: String? {
        return NSStringFromClass(Base.self).components(separatedBy: ".").last
    }
    
    public func removeBackButtonText() {
        self.base.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension Reactive where Base: UIViewController {
    public func present(_ viewControllerToPresent: UIViewController, animated: Bool) -> Completable {
        return Completable.create { observer in
            self.base.present(viewControllerToPresent, animated: animated) { observer(.completed) }
            return Disposables.create {}
        }
    }
    
    public func dismiss(animated: Bool) -> Completable {
        return Completable.create { observer in
            self.base.dismiss(animated: animated) { observer(.completed) }
            return Disposables.create {}
        }
    }
    
    public func showAnimated(child: UIViewController, duration: TimeInterval, configure: @escaping (UIView) -> ()) -> Completable {
        return Completable.deferred {
            self.base.addChild(child)
            configure(child.view)
            child.view.alpha = 0
            self.base.view.addSubview(child.view)
            return UIView.rx
                .animate(duration: duration) { child.view.alpha = 1 }
                .do(onCompleted: { child.didMove(toParent: self.base) })
        }
    }
    
    public func hideAnimated(child: UIViewController, duration: TimeInterval) -> Completable {
        return Completable.deferred {
            child.willMove(toParent: nil)
            return UIView.rx
                .animate(duration: duration) { child.view.alpha = 0 }
                .do(onCompleted: { child.view.removeFromSuperview(); child.removeFromParent() })
        }
    }
    
    public func removeChildViewControllers(duration: TimeInterval) -> Completable {
        guard !self.base.children.isEmpty else { return Completable.empty() }
        return Completable.merge(self.base.children.map { (child: UIViewController) -> Completable in
            child.willMove(toParent: nil)
            return UIView.rx
                .animate(duration: duration) { child.view.alpha = 0 }
                .do(onCompleted: { child.view.removeFromSuperview(); child.removeFromParent() })
        })
    }
}
