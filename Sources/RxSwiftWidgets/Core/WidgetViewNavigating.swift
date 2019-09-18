//
//  NavigationWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 9/16/19.
//

import UIKit

/// Protocol indicates that current widget view should wraps its viewcontroller in a navigation controller.
public protocol WidgetViewNavigating: WidgetView {

    /// Returns a custom UINavigationController that's used to wrap the current widget's view controller.
    func navigationController(with context: WidgetContext) -> UINavigationController

}

extension WidgetFactory {

    public static var defaultNavigationController: (_ context: WidgetContext) -> UINavigationController = { _ in
        return UINavigationController()
    }

}

extension WidgetViewNavigating {

    /// Returns a custom UINavigationController that's used to wrap the current widget's view controller.
    ///
    /// Default implementation returns a plain UINavigationController.
    ///
    public func navigationController(with context: WidgetContext) -> UINavigationController {
        WidgetFactory.defaultNavigationController(context)
    }

}

extension WidgetViewType {

    /// Allows any widget to be pushed or presented on the navigation stack. Calls the widget's build function and then
    /// wraps the result in an UIWidgetHostController.
    ///
    /// If Self is WidgetViewNavigating then a UINavigationController is constructed and wrapped around the host controller.
    ///
    public func controller(with context: WidgetContext) -> UIViewController {
        if let navigating = self as? WidgetViewNavigating {
            let navigationController = navigating.navigationController(with: context)
            let viewController = UIWidgetHostController(self, with: context)
            navigationController.addChild(viewController)
            return navigationController
        }
        return UIWidgetHostController(self, with: context)
    }

}
