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
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "HStackWidget()" }

    public var widgets: [Widget]
    public var widgetsBuilder: AnyObservableListBuilder?
    public var modifiers = WidgetModifiers()

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
    }

    public init<Item>(_ builder: ObservableListBuilder<Item>) {
        self.widgets = []
        self.widgetsBuilder = AnyObservableListBuilder(builder)
     }

    public func build(with context: WidgetContext) -> UIView {

        let stack = WidgetPrivateStackView()
        let context = modifiers.modified(context, for: stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.insetsLayoutMarginsFromSafeArea = false
        stack.axis = .horizontal
        stack.spacing = UIStackView.spacingUseSystem

        if let insets = modifiers.padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = insets
        }

        for widget in widgets {
            stack.addArrangedSubview(widget.build(with: context))
        }

        if let builder = widgetsBuilder {
            stack.subscribe(to: builder, with: context)
        }

        modifiers.apply(to: stack, with: context)
        
        return stack
    }

    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.alignment, value: alignment))
    }

    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.distribution, value: distribution))
    }

    public func placeholder(_ widgets: [Widget]) -> Self {
        return modified { $0.widgets = widgets }
    }

    public func spacing(_ spacing: CGFloat) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.spacing, value: spacing))
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIStackView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
