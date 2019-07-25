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
    , WidgetPadding {
    
    public var contextModifier: WidgetContextModifier?
    public var modifiers: WidgetModifiers?
    public let widget: Widget
    public var padding: UIEdgeInsets?

    public init(_ widget: Widget) {
        self.widget = widget
    }

    public func build(with context: WidgetContext) -> UIView {

        let context = contextModifier?(context) ?? context
        let subview = widget.build(with: context)

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addSubview(subview)

        subview.widget.applyConstraints(padding: padding)

        modifiers?.apply(to: view, with: context)

        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
