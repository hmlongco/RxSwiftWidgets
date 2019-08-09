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


/// Extends the basic modifification system with modifiers for many of the core UIView attributes.
public protocol WidgetViewModifying: WidgetModifying {

}

// MARK:- UIView Standard Properties

extension WidgetViewModifying {

    public func accessibilityLabel(_ accessibilityLabel: String?) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.accessibilityLabel, value: accessibilityLabel))
    }

    public func alpha(_ alpha: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.alpha, value: alpha))
    }

    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.backgroundColor, value: backgroundColor))
    }

    public func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.clipsToBounds, value: clipsToBounds))
    }

    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.contentMode, value: contentMode))
    }

    public func hidden(_ isHidden: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.isHidden, value: isHidden))
    }

    public func tag<T>(_ id: T) -> Self where T: RawRepresentable, T.RawValue == Int {
        return modified(WidgetModifier(keyPath: \UIView.tag, value: id.rawValue))
    }

    public func tag(_ tag: Int) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.tag, value: tag))
    }

    public func userInteractionEnabled (_ isUserInteractionEnabled: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.isUserInteractionEnabled, value: isUserInteractionEnabled))
    }

}
