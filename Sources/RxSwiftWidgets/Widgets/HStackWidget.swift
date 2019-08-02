//
//  ColumnWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

public struct HStackWidget
    : WidgetsContaining
    , WidgetViewModifying
    , WidgetContextModifiying
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "HStackWidget()" }

    public let widgets: [Widget]

    public var contextModifier: WidgetContextModifier?
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
    }

    public func build(with context: WidgetContext) -> UIView {
        let context = contextModifier?(context) ?? context
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.insetsLayoutMarginsFromSafeArea = false
        stack.axis = .horizontal
        stack.spacing = UIStackView.spacingUseSystem
        if let insets = padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = insets
        }
        for widget in widgets {
            stack.addArrangedSubview(widget.build(with: context))
        }
        modifiers?.apply(to: stack, with: context)
        return stack
    }

    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.alignment, value: alignment))
    }

    public func bind<Item, Observable:ObservableElement>(_ observable: Observable, transform: @escaping (_ item: Item) -> Widget) -> Self
        where Observable.Element == [Item] {
        return bind(observable.asObservable().map { $0.map { transform($0) } })
    }


    public func bind<Observable:ObservableElement>(_ observable: Observable) -> Self where Observable.Element == [Widget] {
        return modified(WidgetModifierBlock({ (stack: WidgetPrivateStackView, context) in
            stack.subscribe(to: observable.asObservable(), with: context)
        }))
    }

    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.distribution, value: distribution))
    }

    public func spacing(_ spacing: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.spacing, value: spacing))
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIStackView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
