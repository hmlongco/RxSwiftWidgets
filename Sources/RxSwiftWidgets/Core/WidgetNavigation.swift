//
//  WidgetNavigation.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift


extension WidgetContext {

    public var navigator: WidgetNavigator? {
        if viewController != nil {
            return WidgetNavigator(self)
        }
        return nil
    }

}



public struct WidgetNavigator {

    var context: WidgetContext

    public init(_ context: WidgetContext) {
        self.context = context
    }

    public var navigationController: UINavigationController? {
        context.viewController?.navigationController
    }

    public func push(widget: Widget, animated: Bool = true) {
        let viewController = UIWidgetHostController(widget, with: context)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func push<ReturnType>(widget: Widget, animated: Bool = true, onDismiss handler: @escaping WidgetDismissibleReturnHandler<ReturnType>) {
        let dismissible = WidgetDismissibleReturn<ReturnType>(presented: false, handler: handler)
        let viewController = UIWidgetHostController(widget, with: context, dismissible: dismissible)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    public func dismiss<Value>(returning value: Value, animated: Bool = true) {
        guard let viewController = context.viewController, let host = viewController as? WidgetDismissibleHost else { return }
        if let dimissible = host.dismissible, let wrapper = dimissible as? WidgetDismissibleReturn<Value> {
            wrapper.handler?(value)
        }
        dismiss(animated: animated)
    }

    public func dismiss(animated: Bool = true) {
        guard let viewController = context.viewController, let host = viewController as? WidgetDismissibleHost else { return }
        if host.dismissible?.presented ?? false {

        } else {
            viewController.navigationController?.popViewController(animated: animated)
        }
    }

//    public func pop(animated: Bool = true) {
//        navigationController?.popViewController(animated: animated)
//    }

}


extension WidgetContext {

    public init(_ viewController: UIViewController) {
        self.attributes = [String(describing: UIViewController.self):viewController]
        self.disposeBag = DisposeBag()
    }

    public var viewController: UIViewController? {
        return get(UIViewController.self)
    }

    public var dismissible: WidgetDismissibleType? {
        return get(WidgetDismissibleType.self)
    }

    public func new(for viewController: UIViewController) -> WidgetContext {
        var context = set(viewController: viewController)
        context.disposeBag = DisposeBag()
        return context
    }

    public func set(viewController: UIViewController) -> WidgetContext {
        return put(viewController as UIViewController)
    }

    public func set(dismissible: WidgetDismissibleType) -> WidgetContext {
        return put(dismissible)
    }

}











extension WidgetContext {

//    // dismissible functionality
//
//    public func present(widget: Widget, animated: Bool = true) {
//        let controller = UIWidgetHostController(widget)
//        let dismissible = WidgetDismissibleType<Void>(viewController: controller, onDismiss: nil, presented: true)
//        controller.context = self.set(dismissible: dismissible)
//        navigationController?.present(controller, animated: animated, completion: nil)
//    }
//
//    public func present<T>(widget: Widget, animated: Bool = true, onDismiss: @escaping WidgetOnDismissHandler<T>) {
//        let controller = UIWidgetHostController(widget)
//        let dismissible = WidgetDismissibleType(viewController: controller, onDismiss: onDismiss, presented: true)
//        controller.context = self.set(dismissible: dismissible)
//        navigationController?.present(controller, animated: animated, completion: nil)
//    }
//
//    public func push(widget: Widget, animated: Bool = true) {
//        let controller = UIWidgetHostController(widget)
//        let dismissible = WidgetDismissibleType<Void>(viewController: controller, onDismiss: nil, presented: false)
//        controller.context = self.set(dismissible: dismissible)
//        navigationController?.pushViewController(controller, animated: animated)
//    }
//
//    public func push<T>(widget: Widget, animated: Bool = true, onDismiss: @escaping WidgetOnDismissHandler<T>) {
//        let controller = UIWidgetHostController(widget)
//        let dismissible = WidgetDismissibleType(viewController: controller, onDismiss: onDismiss, presented: false)
//        controller.context = self.set(dismissible: dismissible)
//        navigationController?.pushViewController(controller, animated: animated)
//    }
//
//    public func dismiss<Value>(returning value: Value) {
//        guard let dismissible = dismissible else { return }
//        if let dismissible = dismissible as? WidgetDismissibleType<Value> {
//            dismissible.onDismiss?(value)
//        }
//        dismissible.dismiss()
//    }
//
//    public func dismiss() {
//        dismissible?.dismiss()
//    }
//
//    public func back(animated: Bool = true) {
//        navigationController?.popViewController(animated: animated)
//    }

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

public protocol WidgetDismissibleType {
    var presented: Bool { get }
}

public struct WidgetDismissibleVoid: WidgetDismissibleType {
    public let presented: Bool
}

public struct WidgetDismissibleReturn<Value>: WidgetDismissibleType {
    public let presented: Bool
    public let handler: WidgetDismissibleReturnHandler<Value>?
}

public typealias WidgetDismissibleReturnHandler<ReturnType> = (_ value: ReturnType) -> Void


//extension WidgetDismissibleType {
//    func dismiss() {
//        guard let viewController = viewController else { return }
//        if presented {
//            viewController.dismiss(animated: true, completion: nil)
//        } else {
//            viewController.navigationController?.popToViewController(viewController, animated: false)
//            viewController.navigationController?.popViewController(animated: true)
//        }
//    }
//}

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
