//
//  Published.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Define Protocols

public protocol WidgetObservable {
    associatedtype Element
    func asObservable() -> Observable<Element>
}

public protocol WidgetBindable: WidgetObservable {
    func bind(to observable: Observable<Element>) -> Disposable
}

// Extend RxSwift

extension Observable: WidgetObservable {
    // just conformance, observables are already observable
}

extension BehaviorRelay: WidgetBindable {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension BehaviorSubject: WidgetBindable {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension PublishRelay: WidgetBindable {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension PublishSubject: WidgetBindable {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}
