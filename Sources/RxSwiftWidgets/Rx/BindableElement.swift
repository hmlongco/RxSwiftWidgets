//
//  BindableElement.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Define Protocols

public protocol BindableElement: ObservableElement {
    func observe(_ observable: Observable<Element>) -> Disposable
}

extension BehaviorRelay: BindableElement {
    public func observe(_ observable: Observable<Element>) -> Disposable {
        observable.subscribe(onNext: { [weak self] (element) in
            self?.accept(element) // only forward onNext events
        })
    }
}

extension BehaviorSubject: BindableElement {
    public func observe(_ observable: Observable<Element>) -> Disposable {
        observable.subscribe(onNext: { [weak self] (element) in
            self?.onNext(element) // only forward onNext events
        })
    }
}

extension PublishRelay: BindableElement {
    public func observe(_ observable: Observable<Element>) -> Disposable {
        observable.subscribe(onNext: { [weak self] (element) in
            self?.accept(element) // only forward onNext events
        })
    }
}

extension PublishSubject: BindableElement {
    public func observe(_ observable: Observable<Element>) -> Disposable {
        observable.subscribe(onNext: { [weak self] (element) in
            self?.onNext(element) // only forward onNext events
        })
    }
}
