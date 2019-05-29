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
    public func asDriverIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Driver<Element> {
        return asDriver(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Driver.empty()
            }
        })
    }
    
    public func asSignalIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Signal<Element> {
        return asSignal(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Signal.empty()
            }
        })
    }
    
    public func takeUntil(includeStopElement: Bool, stopCondition: @escaping (Element) -> Bool) -> Observable<Element> {
        return materialize()
            .flatMapLatest { event -> Observable<Event<Element>> in
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
    
    public func valueOrEmpty<O>(_ selector: @escaping (Element) -> Optional<O>) -> Observable<O> {
        return self.flatMapLatest { selector($0).map(Observable.just) ?? Observable.empty() }
    }
}

extension SharedSequence {
    public func valueOrEmpty<O>(_ selector: @escaping (Element) -> Optional<O>) -> SharedSequence<SharingStrategy, O> {
        return self.flatMapLatest { selector($0).map(SharedSequence<SharingStrategy, O>.just) ?? SharedSequence<SharingStrategy, O>.empty() }
    }
}

extension SharedSequence where Element: Hashable {
    public func delay(_ dueTime: RxTimeInterval, on elements: Set<Element>) -> SharedSequence<SharingStrategy, Element> {
        return self.flatMapLatest { (e: Element) -> SharedSequence<SharingStrategy, Element> in
            return elements.contains(e)
                ? SharedSequence<SharingStrategy, Element>.just(e).delay(dueTime)
                : SharedSequence<SharingStrategy, Element>.just(e)
        }
    }
}

extension SharedSequence where Element == Void {
    public static func timer(_ dueTime: DispatchTimeInterval, period: DispatchTimeInterval) -> SharedSequence<SharingStrategy, Element> {
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
    public func asDriverIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Driver<Element> {
        return asDriver(onErrorRecover: { e in
            reportError(e, file: file, function: function, line: line)
            if Debug.isEnabled {
                fatalError("\(e)")
            } else {
                return Driver.empty()
            }
        })
    }
    
    public func asSignalIgnoringErrors(file: String = #file, function: String = #function, line: Int = #line) -> Signal<Element> {
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
