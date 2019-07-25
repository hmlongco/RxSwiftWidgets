//
//  Widget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

/// Core definition of a widget is an entity capable of building a specific UIView when asked.
public protocol Widget {
    func build(with context: WidgetContext) -> UIView
}

/// A widget that contains or wraps another widget
public protocol WidgetContaining: Widget {
    var widget: Widget { get }
}

/// A widget that holds a list of widgets, usually some form of stack
public protocol WidgetsContaining: Widget {
    var widgets: [Widget] { get }
}
