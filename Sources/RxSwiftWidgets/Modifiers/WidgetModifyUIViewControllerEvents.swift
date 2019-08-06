//
//  WidgetModifyUIViewControllerEvents.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 7/27/19.
//

import UIKit

extension WidgetViewModifying {

    public func onScreenWillAppear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                    .subscribe(onNext: { (arguments) in
                        let animated = arguments.first as? Bool ?? true
                        handler(context.set(animated, for: "animated"))
                    })
                    .disposed(by: context.disposeBag)
            }
        }))
    }

    public func onScreenDidAppear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
                    .subscribe(onNext: { (arguments) in
                        let animated = arguments.first as? Bool ?? true
                        handler(context.set(animated, for: "animated"))
                    })
                    .disposed(by: context.disposeBag)
            }
        }))
    }

    public func onScreenWillDisappear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
                    .subscribe(onNext: { (arguments) in
                        let animated = arguments.first as? Bool ?? true
                        handler(context.set(animated, for: "animated"))
                    })
                    .disposed(by: context.disposeBag)
            }
        }))
    }

    public func onScreenDidDisappear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
                    .subscribe(onNext: { (arguments) in
                        let animated = arguments.first as? Bool ?? true
                        handler(context.set(animated, for: "animated"))
                    })
                    .disposed(by: context.disposeBag)
            }
        }))
    }

}
