//
//  ScrollWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum WidgetScrollAxis {
    case both
    case vertical
    case horizontal
}

public struct ScrollWidget
    : WidgetViewModifying
    , WidgetContaining
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ScrollWidget()" }

    public var widget: Widget
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?
    public var axis = WidgetScrollAxis.vertical

    public init(_ widget: Widget) {
        self.widget = widget
    }

    public func build(with context: WidgetContext) -> UIView {

        let contentView = widget.build(with: context)
        let padding = self.padding ?? UIEdgeInsets.zero

        let view = WidgetScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.axis = axis
        view.padding = padding
        view.addSubview(contentView)

        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding.left).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding.right).isActive = true

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func axis(_ axis: WidgetScrollAxis) -> Self {
        return modified { $0.axis = axis }
    }

    /// Pass an UIScrollViewDelegate object and it will be assigned as the delegate for the generated UIScrollView.
    public func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return modified(WidgetModifierBlock<WidgetScrollView> { view, _ in
            view.delegateReference = delegate
            view.delegate = delegate
        })
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIScrollView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}

internal class WidgetScrollView: UIScrollView, WidgetViewCustomConstraints {

    var axis: WidgetScrollAxis = .both
    var delegateReference: UIScrollViewDelegate?
    var padding: UIEdgeInsets!

    func addCustomConstraints() {
        guard let superview = superview, let subview = subviews.first else { return }
        switch axis {
        case .vertical:
            let padding = self.padding.left + self.padding.right
            subview.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -padding).isActive = true
        case .horizontal:
            let padding = self.padding.top + self.padding.bottom
            subview.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -padding).isActive = true
        case .both:
            break
        }
    }

}
