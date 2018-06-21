//
//  ActivityIndicator.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Disposable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

public class ActivityIndicator : SharedSequenceConvertibleType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: Driver<Bool>
    
    public init() {
        _loading = _variable.asObservable()
            .map { $0 > 0 }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: ActivityIndicator.ifItStillErrors)
    }
    
    private static func ifItStillErrors(_ error: Error) -> Driver<Bool> {
        _ = fatalError("Loader can't fail")
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        _lock.lock()
        _variable.value = _variable.value + 1
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _variable.value = _variable.value - 1
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }
}

public extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

public extension SharedSequence {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> SharedSequence<S, E> {
        return activityIndicator.trackActivityOfObservable(self).asSharedSequence(onErrorRecover: { error in
            fatalErrorInDebugOrReportError(error)
            return SharedSequence.empty()
        })
    }
}
