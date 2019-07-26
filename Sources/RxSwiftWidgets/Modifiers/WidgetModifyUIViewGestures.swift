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

    public func onTap(effect: WidgetTapEffectType? = WidgetTapEffectDim(), handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            let tapGesture = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            tapGesture.rx.event
                .subscribe(onNext: { (gesture) in
                    if let effect = effect {
                        effect.animate(view) {
                            handler(context)
                        }
                    } else {
                        handler(context)
                    }
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

public protocol WidgetTapEffectType {
    func animate(_ view: UIView, _ completion: @escaping () -> Void)
}

public struct WidgetTapEffectDim: WidgetTapEffectType {
    public init() {}
    public func animate(_ view: UIView, _ completion: @escaping () -> Void) {
        let oldAlpha = view.alpha
        UIView.animate(withDuration: 0.05, animations: {
            view.alpha = max(view.alpha - 0.4, 0)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.05, animations: {
                view.alpha = oldAlpha
            }, completion: { completed in
                completion()
            })
        })
    }
}
