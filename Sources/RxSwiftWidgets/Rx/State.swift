//
//  State.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


@propertyWrapper
public struct State<Element>: BindableElement {

    private let relay: BehaviorRelay<Element>

    public init(wrappedValue: Element) {
        relay = BehaviorRelay<Element>(value: wrappedValue)
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

    public func bidirectionalBind(_ observable: Observable<Element>) -> Disposable {
        observable.bind(to: relay)
    }

    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Element == Observer.Element {
        relay.subscribe(observer)
    }

}
