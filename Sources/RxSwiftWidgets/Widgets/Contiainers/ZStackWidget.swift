//
//  ZStackWidget.swift
//  RxSwiftWidgets
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
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ZStackWidget()" }

    public let widgets: [Widget]
    public var modifiers = WidgetModifiers()

    public init(_ widgets: [Widget]) {
        self.widgets = widgets
    }

    public func build(with context: WidgetContext) -> UIView {
        let view = UIView()
        let context = modifiers.modified(context, for: view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = false
        view.backgroundColor = .clear

        for widget in widgets {
            let subview = widget.build(with: context)
            view.addConstrainedSubview(subview, with: modifiers.padding)
        }

        modifiers.apply(to: view, with: context)
        
        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
