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

@propertyWrapper
public struct Published<Element>: WidgetBindable {

    private let relay: BehaviorRelay<Element>

    public init(wrappedValue: Element) {
        relay = BehaviorRelay<Element>(value: wrappedValue)
    }

    public var wrappedValue: Element {
        get { relay.value }
        nonmutating set { relay.accept(newValue) }
    }

    public func accept(_ element: Element) {
        relay.accept(element)
    }

    @available(iOS 13, *)
    public func asBindable() -> some WidgetBindable {
        self
    }

    public func asRelay() -> BehaviorRelay<Element> {
        relay
    }

    public func asObservable() -> Observable<Element> {
        relay.asObservable()
    }

    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: relay)
    }

}

@propertyWrapper
public struct Binding<Element>: WidgetBindable {

    private let relay: BehaviorRelay<Element>

    init(_ publisher: Published<Element>) {
        self.relay = publisher.asRelay()
    }

    public var wrappedValue: Element {
        get { relay.value }
        nonmutating set { relay.accept(newValue) }
    }

    public func accept(_ element: Element) {
        relay.accept(element)
    }

    public func asRelay() -> BehaviorRelay<Element> {
        relay
    }

    public func asObservable() -> Observable<Element> {
        relay.asObservable()
    }

    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: relay)
    }
}
