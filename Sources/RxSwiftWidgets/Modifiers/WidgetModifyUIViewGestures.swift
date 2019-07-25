//
//  WidgetUIViewModifiersCustom.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK:- UIView Widget Properties

extension WidgetViewModifying {

    public func onTap(_ tapped: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            let tapGesture = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            tapGesture.rx.event
                .subscribe(onNext: { (gesture) in
                    tapped(context)
                })
                .disposed(by: context.disposeBag)
        }))
    }

    public func onSwipeLeft(_ swiped: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            let swipeGesture = UISwipeGestureRecognizer()
            swipeGesture.direction = .left
            view.addGestureRecognizer(swipeGesture)
            view.isUserInteractionEnabled = true
            swipeGesture.rx.event
                .subscribe(onNext: { (gesture) in
                    swiped(context)
                })
                .disposed(by: context.disposeBag)
        }))
    }

    public func onSwipeRight(_ swiped: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            let swipeGesture = UISwipeGestureRecognizer()
            swipeGesture.direction = .right
            view.addGestureRecognizer(swipeGesture)
            view.isUserInteractionEnabled = true
            swipeGesture.rx.event
                .subscribe(onNext: { (gesture) in
                    swiped(context)
                })
                .disposed(by: context.disposeBag)
        }))
    }

}

