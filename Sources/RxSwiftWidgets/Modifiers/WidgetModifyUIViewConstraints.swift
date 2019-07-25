//
//  WidgetModifying.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK:- UIView Constraints

extension WidgetViewModifying {

    // compression

    public func contentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            view.setContentCompressionResistancePriority(priority, for: axis)
        })
    }

    // hugging

    public func contentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            view.setContentHuggingPriority(priority, for: axis)
        })
    }

    // height

    public func height(_ height: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(equalToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }

    public func height(min height: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }

    public func height(max height: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let height = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            height.priority = UILayoutPriority(priority)
            height.isActive = true
        })
    }

    // width

    public func width(_ width: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(equalToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }

    public func width(min width: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }

    public func width(max width: CGFloat, priority: Float = 999) -> Self {
        return modified(WidgetModifierBlock<UIView> { view, _ in
            let width = view.widthAnchor.constraint(lessThanOrEqualToConstant: width)
            width.priority = UILayoutPriority(priority)
            width.isActive = true
        })
    }

}
