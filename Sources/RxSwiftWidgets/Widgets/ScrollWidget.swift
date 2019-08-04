//
//  ScrollWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct ScrollWidget
    : WidgetViewModifying
    , WidgetContaining
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ScrollWidget()" }

    public var widget: Widget
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public func build(with context: WidgetContext) -> UIView {
        let subview = widget.build(with: context)

        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)

        subview.widget.applyConstraints(padding: padding)

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIScrollView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
