//
//  WidgetModifying.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK:- UIView Standard Properties

extension WidgetViewModifying {

    public func hidden<Observable:WidgetObservable>(_ observable: Observable) -> Self where Observable.Element == Bool {
        return modified(WidgetModifierBlock<UIView> { view, context in
            observable.asObservable().bind(to: view.rx.isHidden).disposed(by: context.disposeBag)
        })
    }
    
}
