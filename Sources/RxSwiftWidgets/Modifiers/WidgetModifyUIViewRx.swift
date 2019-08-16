//
//  WidgetModifying.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK:- UIView Standard Properties

extension WidgetViewModifying {

    public func hidden<O:ObservableElement>(_ observable: O) -> Self where O.Element == Bool {
        return modified(WidgetModifierBlock<UIView> { view, context in
            observable.asObservable().bind(to: view.rx.isHidden).disposed(by: context.disposeBag)
        })
    }

    public func onEvent<O:ObservableElement, Value>(_ observable: O, handle: @escaping (_ value: Value, _ context: WidgetContext) -> Void) -> Self where O.Element == Value {
        return modified(WidgetModifierBlock({ (_, context) in
            observable.asObservable()
                .subscribe(onNext: { (value) in
                    handle(value, context)
                })
                .disposed(by: context.disposeBag)
        }))
    }

}
