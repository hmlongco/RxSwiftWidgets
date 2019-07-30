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

/// Defines a widget capable of supporting view modifiers
public protocol WidgetModifying: Widget {
    var modifiers: WidgetModifiers? { get set }
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
        if widget.modifiers == nil {
            widget.modifiers = [modifier]
            widget.modifiers?.reserveCapacity(8)
        } else {
            widget.modifiers?.append(modifier)
        }
        return widget
    }

    public func modified(_ modifier: (_ widget: inout Self) -> Void) -> Self {
        var widget = self
        modifier(&widget)
        return widget
    }
}

/// A linked list of view modifiers

public typealias WidgetModifiers = Array<AnyWidgetModifier>

extension WidgetModifiers {
    public func apply(to view: UIView, with context: WidgetContext) {
        self.forEach { $0.apply(to: view, with: context) }
    }
}
