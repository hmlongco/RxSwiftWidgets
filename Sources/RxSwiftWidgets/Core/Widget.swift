//
//  Widget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

/// Base type for any type of widget.
public protocol AnyWidget { }

/// A special-purpose widget capable of building a specific UIViewController when asked.
public protocol WidgetControllerType: AnyWidget {
    /// Builds or returns a UIViewController that wraps the current widget.
    func controller(with context: WidgetContext) -> UIViewController
}

/// Core definition of a widget as an entity capable of building a specific UIView when asked.
public protocol WidgetViewType: WidgetControllerType {
    /// Builds or returns a UIView that represents the current widget.
    func build(with context: WidgetContext) -> UIView
}

/// Convenience type as most widgets are WidgetViewTypes.
public typealias Widget = WidgetViewType

/// Namespace for many RxSwiftWidget Enumerations and Definitions
public struct Widgets { }

/// A widget that contains or wraps another widget
public protocol WidgetContaining: Widget {
    /// Variable containing the wrapped widget
    var widget: Widget { get }
}

/// A widget that holds a list of widgets, usually some form of stack
public protocol WidgetsContaining: Widget {
    /// Variable containing an array of the wrapped widgets
    var widgets: [Widget] { get }
}

/// Common functions on WidgetViewType.
extension WidgetViewType {

    /// Allows any widget to be pushed or presented on the navigation stack.
    public func controller(with context: WidgetContext) -> UIViewController {
        return UIWidgetHostController(self, with: context)
    }

    /// Walks widget tree of WidgetContaining and WidgetsContaining and calls closure on each node.
    public func walk(_ process: (_ widget: Widget) -> Void ) {
        func each(_ widget: Widget) {
            process(widget)
            if let widget = widget as? WidgetContaining {
                each(widget)
            } else if let widget = widget as? WidgetsContaining {
                widget.widgets.forEach { each($0) }
            }
        }
        each(self)
    }

}

