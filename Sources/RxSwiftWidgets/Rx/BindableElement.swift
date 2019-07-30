//
//  BindableElement.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Define Protocols

public protocol BindableElement: ObservableElement {
    func bind(to observable: Observable<Element>) -> Disposable
}

extension BehaviorRelay: BindableElement {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension BehaviorSubject: BindableElement {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension PublishRelay: BindableElement {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}

extension PublishSubject: BindableElement {
    public func bind(to observable: Observable<Element>) -> Disposable {
        observable.bind(to: self)
    }
}
