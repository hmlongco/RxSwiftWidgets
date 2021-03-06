//
//  UIControlWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct UIControlWidget<View:UIControl>
    : Widget
    , WidgetControlModifying
    , CustomDebugStringConvertible {

    public var debugDescription: String { "UIViewWidget()" }

    public var modifiers = WidgetModifiers()
    public var view: View

    public init(_ view: View) {
        self.view = view
    }

    public func build(with context: WidgetContext) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        let context = modifiers.modified(context, for: view)
        modifiers.apply(to: view, with: context)
        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<View>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
