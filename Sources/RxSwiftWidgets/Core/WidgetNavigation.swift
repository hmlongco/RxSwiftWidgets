//
//  WidgetNavigation.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift


public struct WidgetNavigator {

    var context: WidgetContext

    public init(_ context: WidgetContext) {
        self.context = context
    }

    public var navigationController: UINavigationController? {
        context.viewController?.navigationController
    }

    // dismissible functionality

    public func push(widget: Widget, animated: Bool = true) {
        let viewController = UIWidgetHostController(widget, with: context)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func push<ReturnType>(widget: Widget, animated: Bool = true, onDismiss handler: @escaping WidgetDismissibleReturnHandler<ReturnType>) {
        let dismissible = WidgetDismissibleReturn<ReturnType>(handler)
        let viewController = UIWidgetHostController(widget, with: context, dismissible: dismissible)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func dismiss<Value>(returning value: Value, animated: Bool = true) {
        if let dimissible = context.dismissible as? WidgetDismissibleReturn<Value> {
            dimissible.handler(value)
        }
        dismiss(animated: animated)
    }

    public func dismiss(animated: Bool = true) {
        guard let viewController = context.viewController else { return }
        viewController.navigationController?.popToViewController(viewController, animated: false)
        viewController.navigationController?.popViewController(animated: animated)
    }

    // standard functionality

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
        context.viewController?.present(viewController, animated: animated, completion: nil)
    }

    public func dismissViewController(animated: Bool = true) {
        context.viewController?.dismiss(animated: animated, completion: nil)
    }

}


extension WidgetContext {

    public var navigator: WidgetNavigator? {
        if viewController != nil {
            return WidgetNavigator(self)
        }
        return nil
    }

    public func new() -> WidgetContext {
        var context = self
        context.disposeBag = DisposeBag()
        return context
    }

    public func set(viewController: UIViewController) -> WidgetContext {
        var context = self
        context.viewController = viewController
        return context
    }

    public var dismissible: WidgetDismissibleType? {
        return get(WidgetDismissibleType.self)
    }

    public func set(dismissible: WidgetDismissibleType?) -> WidgetContext {
        if let dismissible = dismissible {
            return put(dismissible)
        }
        return self
    }

}

fileprivate struct UIViewControllerBox {
    weak var viewController: UIViewController?
}

