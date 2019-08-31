//
//  SpacerWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public typealias FlexibleSpaceWidget = SpacerWidget

public struct SpacerWidget: Widget
    , CustomDebugStringConvertible {

    public var debugDescription: String { "SpacerWidget()" }

    private var h: CGFloat?
    private var w: CGFloat?

    public init(h: CGFloat? = nil, w: CGFloat? = nil) {
        self.h = h
        self.w = w
    }

    public func build(with context: WidgetContext) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        if let h = h {
            view.heightAnchor.constraint(equalToConstant: h).isActive = true
        } else {
            view.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        if let w = w {
            view.widthAnchor.constraint(equalToConstant: w).isActive = true
        } else {
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        return view
    }

}
