//
//  WidgetNavigation.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public typealias WidgetDismissibleHandler<ReturnType> = (_ value: ReturnType) -> Void

public protocol AnyWidgetDismissible {
    var viewController: UIViewController? { get }
    var presented: Bool { get }
    func dismiss()
}

extension AnyWidgetDismissible {
    func dismiss() {
        guard let viewController = viewController else { return }
        if presented {
            viewController.dismiss(animated: true, completion: nil)
        } else {
            viewController.navigationController?.popToViewController(viewController, animated: false)
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}

extension WidgetContext {

    // dismissible functionality

    public func present<T>(widget: Widget, animated: Bool = true, onDismiss: WidgetDismissibleHandler<T>? = nil) {
        let controller = UIWidgetHostController(widget)
        let dismissible = WidgetDismissibleType(viewController: controller, onDismiss: onDismiss, presented: true)
        controller.context = self.set(dismissible: dismissible)
        navigationController?.present(controller, animated: animated, completion: nil)
    }

    public func push<T>(widget: Widget, animated: Bool = true, onDismiss: WidgetDismissibleHandler<T>? = nil) {
        let controller = UIWidgetHostController(widget)
        let dismissible = WidgetDismissibleType(viewController: controller, onDismiss: onDismiss, presented: false)
        controller.context = self.set(dismissible: dismissible)
        navigationController?.pushViewController(controller, animated: animated)
    }

    public func dismiss<Value>(returning value: Value) {
        guard let dismissible = dismissible else { return }
        if let dismissible = dismissible as? WidgetDismissibleType<Value> {
            dismissible.onDismiss?(value)
        }
        dismissible.dismiss()
    }

    public func dismiss() {
        dismissible?.dismiss()
    }

    public func back(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    // standard functionality

    public var navigationController: UINavigationController? {
        viewController?.navigationController
    }

    public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    public func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    public func presentViewController(_ viewController: UIViewController, animated: Bool = true) {
        self.viewController?.present(viewController, animated: animated, completion: nil)
    }

    public func dismissViewController(animated: Bool = true) {
        self.viewController?.dismiss(animated: animated, completion: nil)
    }

}

internal struct WidgetDismissibleType<ReturnType>: AnyWidgetDismissible {
    public weak var viewController: UIViewController?
    public let onDismiss: WidgetDismissibleHandler<ReturnType>?
    public let presented: Bool
}

extension WidgetModifying {

    public func navigationBar(title: String, preferLargeTitles: Bool? = nil, hidden: Bool? = nil) -> Self {
        return modified(WidgetModifierBlock<UIView> { _, context in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                    .subscribe(onNext: { _ in
                        context.viewController?.title = title
                        if let largeTitles = preferLargeTitles {
                            context.navigationController?.navigationBar.prefersLargeTitles = largeTitles
                        }
                        if let hidden = hidden {
                            context.navigationController?.isNavigationBarHidden = hidden
                        }
                    })
                    .disposed(by: context.disposeBag)
            }
        })
    }

}

extension WidgetViewModifying {

    public func onWillAppear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
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

    public func onDidAppear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
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

    public func onWillDisappear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
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

    public func onDidDisappear(_ handler: @escaping (WidgetContext) -> Void) -> Self {
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
