//
//  Observable+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    public func asDriverIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Driver<E> {
        return asDriver(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Driver.empty()
            }
        })
    }
    
    public func asSignalIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Signal<E> {
        return asSignal(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Signal.empty()
            }
        })
    }
    
    public func takeUntil(includeStopElement: Bool, stopCondition: @escaping (E) -> Bool) -> Observable<E> {
        return materialize()
            .flatMapLatest { event -> Observable<Event<E>> in
                guard case let .next(element) = event else {
                    return Observable.just(event)
                }
                if stopCondition(element) {
                    return includeStopElement ? Observable.of(event, .completed) : Observable.just(event)
                }
                return Observable.just(event)
            }
            .dematerialize()
    }
    
    public func valueOrEmpty<O>(_ selector: @escaping (E) -> Optional<O>) -> Observable<O> {
        return self.flatMapLatest { selector($0).map(Observable.just) ?? Observable.empty() }
    }
}

extension SharedSequence {
    public func valueOrEmpty<O>(_ selector: @escaping (E) -> Optional<O>) -> SharedSequence<S, O> {
        return self.flatMapLatest { selector($0).map(SharedSequence<S, O>.just) ?? SharedSequence<S, O>.empty() }
    }
}

extension SharedSequence where E: Hashable {
    public func delay(_ dueTime: RxTimeInterval, on elements: Set<E>) -> SharedSequence<S, E> {
        return self.flatMapLatest { (e: E) -> SharedSequence<S, E> in
            return elements.contains(e)
                ? SharedSequence<S, E>.just(e).delay(dueTime)
                : SharedSequence<S, E>.just(e)
        }
    }
}

extension SharedSequence where E == Void {
    public static func timer(_ dueTime: DispatchTimeInterval, period: DispatchTimeInterval) -> SharedSequence<S, E> {
        return Observable.create { observer in
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            timer.schedule(deadline: DispatchTime.now() + dueTime, repeating: period, leeway: DispatchTimeInterval.nanoseconds(0))
            
            var timerReference: DispatchSourceTimer? = timer
            let cancelTimer = Disposables.create {
                timerReference?.cancel()
                timerReference = nil
                observer.on(.completed)
            }
            
            timer.setEventHandler(handler: {
                if cancelTimer.isDisposed { return }
                observer.on(.next(()))
            })
            
            timer.resume()
            return cancelTimer
            }
            .asSharedSequence(onErrorRecover: { error in
                fatalErrorInDebugOrReportError(error)
                return SharedSequence.empty()
            })
    }
}

extension PrimitiveSequence {
    public func asDriverIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Driver<E> {
        return asDriver(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Driver.empty()
            }
        })
    }
    
    public func asSignalIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Signal<E> {
        return asSignal(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Signal.empty()
            }
        })
    }
}
