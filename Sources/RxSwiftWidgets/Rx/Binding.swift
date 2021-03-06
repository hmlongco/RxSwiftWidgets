//
//  Binding.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@propertyWrapper
public struct Binding<Element>: BindableElement {

    private let relay: BehaviorRelay<Element>

    init(_ relay: BehaviorRelay<Element>) {
        self.relay = relay
    }

    public var value: Element {
        get { relay.value }
        nonmutating set { relay.accept(newValue) }
    }

    public var wrappedValue: Element {
        get { relay.value }
        nonmutating set { relay.accept(newValue) }
    }

    public var projectedValue: Binding<Element> {
        Binding(relay)
    }

    public func asBinding() -> Binding<Element> {
        Binding(relay)
    }

    public func asObservable() -> Observable<Element> {
        relay.asObservable()
    }

    public func observe(_ observable: Observable<Element>) -> Disposable {
        observable.subscribe(onNext: { (element) in
            self.relay.accept(element) // only forward onNext events
        })
    }

    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Element == Observer.Element {
        relay.subscribe(observer)
    }
}
