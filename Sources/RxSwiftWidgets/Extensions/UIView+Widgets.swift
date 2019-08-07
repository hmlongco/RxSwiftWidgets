//
//  UIView+Widgets.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public struct WidgetViewAttributes {

    var position: WidgetPosition = .fill
    var safeArea = true

}

public protocol WidgetViewExtendable: UIView {

    var widget: WidgetViewAttributes { get set }

    func build(widget: Widget, with context: WidgetContext)
    func addConstrainedSubview(_ subview: UIView, with padding: UIEdgeInsets?)

}

public protocol WidgetViewCustomConstraints {
    func addCustomConstraints()
}

extension UIView: WidgetViewExtendable {

    private static var WidgetViewAttributesKey: UInt8 = 0

    public func build(widget: Widget, with context: WidgetContext) {
        let context = context.set(view: self)
        let view = widget.build(with: context)
        addConstrainedSubview(view)
    }

    public func addConstrainedSubview(_ subview: UIView, with padding: UIEdgeInsets? = nil) {
        let attr = subview.widget
        let padding = padding ?? UIEdgeInsets.zero

        self.addSubview(subview)

        WidgetPosition.applyConstraints(subview, position: attr.position, padding: padding, safeArea: attr.safeArea)

        if let customView = subview as? WidgetViewCustomConstraints {
            customView.addCustomConstraints()
        }
    }

   public var widget: WidgetViewAttributes {
        get {
            if let attributes = objc_getAssociatedObject( self, &UIView.WidgetViewAttributesKey ) as? WidgetViewAttributes {
                return attributes
            }
            return WidgetViewAttributes()
        }
        set {
            objc_setAssociatedObject(self, &UIView.WidgetViewAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func viewWithID<T,V:UIView>(_ id: T) -> V? where T: RawRepresentable, T.RawValue == Int {
        return viewWithTag(id.rawValue) as? V
    }

}
