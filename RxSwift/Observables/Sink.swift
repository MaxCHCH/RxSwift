//
//  Sink.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/19/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

class Sink<Element> : Disposable {
    fileprivate let _observer: Observer<Element>
    fileprivate let _cancel: Cancelable
    fileprivate var _disposed: Bool

    #if DEBUG
        fileprivate let _synchronizationTracker = SynchronizationTracker()
    #endif

    init(observer: Observer<Element>, cancel: Cancelable) {
#if TRACE_RESOURCES
        let _ = Resources.incrementTotal()
#endif
        _observer = observer
        _cancel = cancel
        _disposed = false
    }

    final func forwardOnNext(_ next: Element) {
        #if DEBUG
            _synchronizationTracker.register(synchronizationErrorMessage: .default)
            defer { _synchronizationTracker.unregister() }
        #endif
        if _disposed {
            return
        }
        _observer.onNext(next)
    }

    final func forwardOnError(_ error: Error) {
        #if DEBUG
            _synchronizationTracker.register(synchronizationErrorMessage: .default)
            defer { _synchronizationTracker.unregister() }
        #endif
        if _disposed {
            return
        }
        _observer.onError(error)
    }

    final func forwardOnCompleted() {
        #if DEBUG
            _synchronizationTracker.register(synchronizationErrorMessage: .default)
            defer { _synchronizationTracker.unregister() }
        #endif
        if _disposed {
            return
        }
        _observer.onCompleted()
    }

    final var disposed: Bool {
        return _disposed
    }

    func dispose() {
        _disposed = true
        _cancel.dispose()
    }

    deinit {
#if TRACE_RESOURCES
       let _ =  Resources.decrementTotal()
#endif
    }
}
