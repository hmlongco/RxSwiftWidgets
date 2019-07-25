//
//  UIView+Widgets.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public protocol WidgetViewExtendable {
    var widget: WidgetViewAttributes { get set }
}

extension UIView: WidgetViewExtendable {

    private static var WidgetViewAttributesKey: UInt8 = 0

    public func build(widget: Widget, with context: WidgetContext) {
        self.widget.buildViews(from: widget, with: context)
    }

    public func viewWithID<T,V:UIView>(_ id: T) -> V? where T: RawRepresentable, T.RawValue == Int {
        return viewWithTag(id.rawValue) as? V
    }

    public var widget: WidgetViewAttributes {
        get {
            if let attributes = objc_getAssociatedObject( self, &UIView.WidgetViewAttributesKey ) as? WidgetViewAttributes {
                return attributes
            }
            return WidgetViewAttributes(view: self)
        }
        set {
            objc_setAssociatedObject(self, &UIView.WidgetViewAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}

public struct WidgetViewAttributes {

    weak var view: UIView?

    var position: WidgetPosition = .fill
    var safeArea = true

}

extension WidgetViewAttributes {

    public func buildViews(from widgetTree: Widget, with context: WidgetContext) {
        let subview = widgetTree.build(with: context)
        view?.subviews.first?.removeFromSuperview()
        view?.addSubview(subview)
        subview.widget.applyConstraints()
    }

    public func applyConstraints(padding: UIEdgeInsets? = nil) {
        guard let view = view else { return }
        WidgetPosition.applyConstraints(view, position: position, padding: padding ?? UIEdgeInsets.zero, safeArea: safeArea)
    }

}
