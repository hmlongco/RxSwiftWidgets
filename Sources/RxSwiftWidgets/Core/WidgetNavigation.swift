//
//  WidgetNavigation.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

/// WidgetNavigator provides access to the current UINavgiationController and navigation stack.
public struct WidgetNavigator {

    var context: WidgetContext

    public init(_ context: WidgetContext) {
        self.context = context
    }

    /// Returns the current UINavigation controller for the current context.
    public var navigationController: UINavigationController? {
        context.viewController?.navigationController
    }

    // dismissible functionality

    /// Pushes the widget onto the navigation stack in a new UIWidgetHostController.
    public func push(_ widget: Widget, animated: Bool = true) {
        guard let widget = widget as? WidgetViewType else { return }
        let context = self.context.set(presentation: .pushed)
        let viewController = UIWidgetHostController(widget, with: context)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// Pushes the widget onto the navigation stack in a new UIWidgetHostController with a return value handler.
    public func push<ReturnType>(_ widget: Widget, animated: Bool = true, onDismiss handler: @escaping WidgetDismissibleReturnHandler<ReturnType>) {
        guard let widget = widget as? WidgetViewType else { return }
        let context = self.context.set(presentation: .pushed)
        let dismissible = WidgetDismissibleReturn<ReturnType>(handler)
        let viewController = UIWidgetHostController(widget, with: context, dismissible: dismissible)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// Presents a widget on the navigation stack in a new UIWidgetHostController.
    public func present(_ widget: Widget, animated: Bool = true) {
        guard let widget = widget as? WidgetViewType else { return }
        let context = self.context.set(presentation: .presented)
        let viewController = UIWidgetHostController(widget, with: context)
        navigationController?.present(viewController, animated: animated, completion: nil)
    }

    /// Presents a widget on the navigation stack in a new UIWidgetHostController with a return value handler.
    public func present<ReturnType>(_ widget: Widget, animated: Bool = true, onDismiss handler: @escaping WidgetDismissibleReturnHandler<ReturnType>) {
        guard let widget = widget as? WidgetViewType else { return }
        let context = self.context.set(presentation: .presented)
        let dismissible = WidgetDismissibleReturn<ReturnType>(handler)
        let viewController = UIWidgetHostController(widget, with: context, dismissible: dismissible)
        navigationController?.present(viewController, animated: animated, completion: nil)
    }

    public func present(_ widget: WidgetController, animated: Bool = true) {
        let context = self.context.set(presentation: .alert)
        let viewController = widget.build(with: context)
        navigationController?.present(viewController, animated: animated, completion: nil)
    }

    /// Pops or dismisses the current view controller, returning a value that will be passed to the onDismiss handler.
    public func dismiss<Value>(returning value: Value, animated: Bool = true) {
        if let dimissible = context.dismissible as? WidgetDismissibleReturn<Value> {
            dimissible.handler(value)
        }
        dismiss(animated: animated)
    }

    /// Pops or dismisses the current view controller, dependent upon the presentation state.
    public func dismiss(animated: Bool = true) {
        guard let viewController = context.viewController else {
            return
        }
        switch self.context.presentation {
        case .alert, .presented, .sheet:
            viewController.dismiss(animated: animated, completion: nil)
        case .pushed:
            viewController.navigationController?.popToViewController(viewController, animated: false)
            viewController.navigationController?.popViewController(animated: animated)
        }
    }

    // standard functionality

    /// Pushes a non-widget baseed view controller onto the current navigation stack.
    public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// Pops a view controller from the current navigation stack.
    public func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// Pops to the root view controller on the current navigation stack.
    public func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    /// Presents a view controller using the current navigation stack.
    public func presentViewController(_ viewController: UIViewController, animated: Bool = true) {
        context.viewController?.present(viewController, animated: animated, completion: nil)
    }

    /// Dismisses a view controller from the current navigation stack.
    public func dismissViewController(animated: Bool = true) {
        context.viewController?.dismiss(animated: animated, completion: nil)
    }

}


extension WidgetContext {

    /// Returns the Navigator for the current context.
    public var navigator: WidgetNavigator? {
        if viewController != nil {
            return WidgetNavigator(self)
        }
        return nil
    }

    /// Returns the current context with a new RxSwift DisposeBag for subscriptions.
    public func new() -> WidgetContext {
        var context = self
        context.disposeBag = DisposeBag()
        return context
    }

    /// Sets the current view controller to be the passed view controller.
    public func set(viewController: UIViewController) -> WidgetContext {
        var context = self
        context.viewController = viewController
        return context
    }

    /// Returns the current navigation dismissible, if any.
    public var dismissible: WidgetDismissibleType? {
        return get(WidgetDismissibleType.self)
    }

    /// Sets the current navigation dismissible.
    public func set(dismissible: WidgetDismissibleType?) -> WidgetContext {
        if let dismissible = dismissible {
            return put(dismissible)
        }
        return self
    }

    /// Returns the current navigation presentation type for the current view controller.
    public var presentation: WidgetDismissiblePresentationType {
        return find(WidgetDismissiblePresentationType.self) ?? .pushed
    }

    /// Sets the current navigation presentation type for the current view controller.
    public func set(presentation: WidgetDismissiblePresentationType) -> WidgetContext {
        return put(presentation)
    }

}

fileprivate struct UIViewControllerBox {
    weak var viewController: UIViewController?
}

