//
//  ViewWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct UIViewWidget<View:UIView>
    : Widget
    , WidgetViewModifying
    , CustomDebugStringConvertible {

    public var debugDescription: String { "UIViewWidget()" }

    public var modifiers = WidgetModifiers()
    public var view: View

    public init(_ view: View) {
        self.view = view
    }

    public func build(with context: WidgetContext) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        modifiers.apply(to: view, with: context.set(view: view))
        return view
    }

    public func with(_ block: @escaping WidgetModifierBlockType<View>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
