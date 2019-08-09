//
//  WidgetControlModifying.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


/// Extends the basic modifification system with modifiers for many of the core UIControl attributes.
public protocol WidgetControlModifying: WidgetViewModifying {

}

// MARK:- UIView Standard Properties

extension WidgetControlModifying {

    /// Sets enabled for control
    public func enabled(_ isEnabled: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIControl.isEnabled, value: isEnabled))
    }

    /// Sets selected for control
    public func selected(_ isSelected: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIControl.isSelected, value: isSelected))
    }

    public func tintColor(_ tintColor: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIControl.tintColor, value: tintColor))
    }

}
