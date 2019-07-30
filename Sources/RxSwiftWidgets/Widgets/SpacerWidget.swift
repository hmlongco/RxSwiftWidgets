//
//  SpacerWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public struct SpacerWidget: Widget
    , CustomDebugStringConvertible {

    public var debugDescription: String { "SpacerWidget()" }

    public var modifiers: WidgetModifiers?

    public init() {}

    public func build(with context: WidgetContext) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }

}
