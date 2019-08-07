//
//  SpinnerWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct SpinnerWidget: WidgetViewModifying
    , CustomDebugStringConvertible {

    public var debugDescription: String { "SpinnerWidget()" }

    public var modifiers: WidgetModifiers?

    public init() {}

    public func build(with context: WidgetContext) -> UIView {
        let view = UIActivityIndicatorView(frame: .zero)
        let context = context.set(view: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        modifiers?.apply(to: view, with: context)
        return view
    }

    public func color(_ color: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIActivityIndicatorView.color, value: color))
    }

}
