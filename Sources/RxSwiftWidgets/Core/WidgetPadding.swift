//
//  WidgetPadding.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Protocol defines view capable of supporting custom padding
public protocol WidgetPadding: WidgetModifying {
    var padding: UIEdgeInsets? { get set }
}

extension WidgetPadding {

    public func padding(insets: UIEdgeInsets) -> Self {
        var widget = self
        widget.padding = insets
        return widget
    }

    public func padding(_ padding: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    public func padding(h: CGFloat, v: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h))
    }

    public func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        return self.padding(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

}
