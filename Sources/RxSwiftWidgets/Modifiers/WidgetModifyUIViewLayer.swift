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


// MARK:- UIView Layer Properties

extension WidgetViewModifying {

    public func borderColor(_ borderColor: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.borderColor, value: borderColor.cgColor))
    }

    public func borderWidth(_ borderWidth: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.borderWidth, value: borderWidth))
    }

    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.cornerRadius, value: cornerRadius))
    }

    public func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.shadowRadius, value: shadowRadius))
    }

    public func shadowOpacity(_ shadowOpacity: Float) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.shadowOpacity, value: shadowOpacity))
    }

    public func shadowOffset(_ shadowOffset: CGSize) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.shadowOffset, value: shadowOffset))
    }

    public func shadowColor(_ shadowColor: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.shadowColor, value: shadowColor.cgColor))
    }

}
