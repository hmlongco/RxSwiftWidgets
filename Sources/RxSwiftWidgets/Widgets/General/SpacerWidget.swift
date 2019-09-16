//
//  SpacerWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public typealias FlexibleSpaceWidget = SpacerWidget

public struct SpacerWidget
    : WidgetViewType
    , CustomDebugStringConvertible {

    public var debugDescription: String { "SpacerWidget()" }

    private var h: CGFloat?
    private var v: CGFloat?

    public init(h: CGFloat? = nil, v: CGFloat? = nil) {
        self.h = h
        self.v = v
    }

    public func build(with context: WidgetContext) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            view.translatesAutoresizingMaskIntoConstraints = false
            if let h = h {
                view.widthAnchor.constraint(equalToConstant: h).isActive = true
            } else {
                view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            }
            if let v = v {
                view.heightAnchor.constraint(equalToConstant: v).isActive = true
            } else {
                view.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
            return view
        }

}
