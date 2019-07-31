//
//  ObservableElement.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Define Protocols

public protocol ObservableElement: ObservableType {
    associatedtype Element
    func asObservable() -> Observable<Element>
}

extension Observable: ObservableElement {
    // just conformance, observables are already observable
}
