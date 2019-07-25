//
//  ZStackWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

public struct ZStackWidget
    : WidgetsContaining
    , WidgetViewModifying
    , WidgetContextModifiying
    , WidgetPadding {

    public let widgets: [Widget]
    
    public var contextModifier: WidgetContextModifier?
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public init(_ widgets: [Widget]) {
        self.widgets = widgets
    }

    public func build(with context: WidgetContext) -> UIView {
        let context = contextModifier?(context) ?? context

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = false
        view.backgroundColor = .clear

        for widget in widgets {
            let subview = widget.build(with: context)
            view.addSubview(subview)
            subview.widget.applyConstraints(padding: padding)
        }

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}