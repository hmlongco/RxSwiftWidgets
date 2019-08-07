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

    public func border(color: UIColor = .gray, width: CGFloat = 1, radius: CGFloat = 0) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
            view.layer.cornerRadius = radius
            view.clipsToBounds = true
        }))
    }

    public func borderColor(_ borderColor: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.borderColor, value: borderColor.cgColor))
    }

    public func borderWidth(_ borderWidth: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.layer.borderWidth, value: borderWidth))
    }

    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            view.layer.cornerRadius = cornerRadius
            view.clipsToBounds = true
        }))
    }

    public func shadow(offset: CGSize, color: UIColor = .gray, opacity: Float = 0.5, radius: CGFloat = 0) -> Self {
        return modified(WidgetModifierBlock({ (view, context) in
            view.layer.shadowOffset = offset
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = opacity
            view.layer.shadowRadius = radius
        }))
    }
    
}
