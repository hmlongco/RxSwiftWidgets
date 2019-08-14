//
//  ContainerWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct ContainerWidget
    : WidgetContaining
    , WidgetContextModifiying
    , WidgetViewModifying
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ContainerWidget()" }

    public var contextModifier: WidgetContextModifier?
    public var modifiers = WidgetModifiers()
    public let widget: Widget

    public init(_ widget: Widget) {
        self.widget = widget
    }

    public func build(with context: WidgetContext) -> UIView {

        let view = UIView()
        let context = (contextModifier?(context) ?? context).set(view: view)
        let subview = widget.build(with: context)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addConstrainedSubview(subview, with: modifiers.padding)

        modifiers.apply(to: view, with: context)

        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
