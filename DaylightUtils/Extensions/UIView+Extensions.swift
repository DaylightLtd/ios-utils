//
//  UIView+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension Utils where Base: UIView {
    public func capture() -> UIImage {
        return self.capture(size: self.base.bounds.size, scale: UIScreen.main.scale)
    }
    
    public func capture(size: CGSize, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalErrorInDebugOrReportError("Failed to get current context")
            return UIImage()
        }
        
        self.base.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalErrorInDebugOrReportError("Failed to get image from image context")
            return UIImage()
        }
        
        UIGraphicsEndImageContext()
        return image
    }
    
    public static var xibName: String? {
        return NSStringFromClass(Base.self).components(separatedBy: ".").last
    }
}

extension Reactive where Base: UIView {
    public static func animate(duration: TimeInterval, animations: @escaping () -> Void) -> Completable {
        return Completable.create { observer in
            UIView.animate(withDuration: duration, animations: animations, completion: { _ in
                observer(.completed)
            })
            return Disposables.create {}
        }
    }
    
    public static func animate(duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, animations: @escaping () -> Void) -> Completable {
        return Completable.create { observer in
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: { _ in
                observer(.completed)
            })
            return Disposables.create {}
        }
    }
    
    public static func animate(duration: TimeInterval, delay: TimeInterval, springWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: @escaping () -> Void) -> Completable {
        return Completable.create { observer in
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: { _ in
                observer(.completed)
            })
            return Disposables.create {}
        }
    }
    
    public func animateKeyframes(images: [String], duration: TimeInterval, repeatCount: Float, keyTimes: [Double]? = nil, timingFunction: CAMediaTimingFunction? = nil) -> Completable {
        return Completable.create { observer in
            let animation = CAKeyframeAnimation(keyPath: "contents")
            animation.values = images.map { UIImage(named: $0)?.cgImage as Any }
            animation.keyTimes = keyTimes?.map(NSNumber.init(value:))
            animation.duration = duration
            animation.repeatCount = repeatCount
            animation.timingFunction = timingFunction
            
            CATransaction.begin()
            CATransaction.setCompletionBlock { observer(.completed) }
            self.base.layer.add(animation, forKey: "keyframe")
            CATransaction.commit()
            
            return Disposables.create {
                self.base.layer.removeAnimation(forKey: "keyframe")
            }
        }
    }
}
