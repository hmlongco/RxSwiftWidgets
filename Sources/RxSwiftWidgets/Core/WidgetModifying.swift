//
//  WidgetModifying.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// List of view modifiers
public struct WidgetModifiers {
    /// List of additional modifiers
    public var list: Array<AnyWidgetModifier>?
    /// Modifier for primary view data binding, if any
    public var binding: AnyWidgetModifier? = nil
    /// Used if WiddgetPadding is supported
    public var padding: UIEdgeInsets? = nil
    /// Public initialization
    public init() {}
}

extension WidgetModifiers {
    public func apply(to view: UIView, with context: WidgetContext) {
        self.binding?.apply(to: view, with: context)
        self.list?.forEach { $0.apply(to: view, with: context) }
    }
}


/// Defines a widget capable of supporting view modifiers
public protocol WidgetModifying: Widget {
    var modifiers: WidgetModifiers { get set }
}

extension WidgetModifying {

    /// Returns new widget with view modifier added to modification array.
    ///
    /// This is the primary function behind widget chaining in struct-based widgets. Same mechanism will work for class-based widgets
    /// as widget effectively returns iteself with new list entry.
    ///
    /// Arrays choosen over modification linked-list as each element in a list would need dynamic allocation whereas Swift arrays expand
    /// exponentially and would also have improved performance iterating through the array.
    public func modified(_ modifier: AnyWidgetModifier) -> Self {
        var widget = self
        if widget.modifiers.list == nil {
            widget.modifiers.list = [modifier]
            widget.modifiers.list?.reserveCapacity(8)
        } else {
            widget.modifiers.list?.append(modifier)
        }
        return widget
    }

    public func modified(_ modifier: (_ widget: inout Self) -> Void) -> Self {
        var widget = self
        modifier(&widget)
        return widget
    }
}
