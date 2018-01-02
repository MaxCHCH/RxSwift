//
//  ObservableType.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 8/8/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

public struct Observer<Element> {
    public let next: (Element) -> ()
    public let error: (Error) -> ()
    public let completed: () -> ()

    public init(next: @escaping (Element) -> (), error: @escaping (Error) -> (), completed: @escaping () -> ()) {
        self.next = next
        self.error = error
        self.completed = completed
    }

    @inline(__always)
    public func onNext(_ next: Element) {
        self.next(next)
    }

    @inline(__always)
    public func onError(_ error: Error) {
        self.error(error)
    }

    @inline(__always)
    public func onCompleted() {
        self.completed()
    }
}

/// Represents a push style sequence.
public protocol ObservableType : ObservableConvertibleType {
    /**
     Subscribes `observer` to receive events for this sequence.

     ### Grammar

     **Next\* (Error | Completed)?**

     * sequences can produce zero or more elements so zero or more `Next` events can be sent to `observer`
     * once an `Error` or `Completed` event is sent, the sequence terminates and can't produce any other elements

     It is possible that events are sent from different threads, but no two events can be sent concurrently to
     `observer`.

     ### Resource Management

     When sequence sends `Complete` or `Error` event all internal resources that compute sequence elements
     will be freed.

     To cancel production of sequence elements and free resources immediately, call `dispose` on returned
     subscription.

     - returns: Subscription for `observer` that can be used to cancel production of sequence elements and free resources.
     */
    func subscribe(_ observer: Observer<E>) -> Disposable
}

extension ObservableType {
    
    /// Default implementation of converting `ObservableType` to `Observable`.
    public func asObservable() -> Observable<E> {
        return Observable.createAnonymous(self.subscribe)
    }
}
