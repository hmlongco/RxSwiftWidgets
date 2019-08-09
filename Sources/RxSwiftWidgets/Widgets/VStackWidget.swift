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

public struct VStackWidget
    : WidgetsContaining
    , WidgetViewModifying
    , WidgetContextModifiying
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "VStackWidget()" }

    public var widgets: [Widget]
    public var widgetsBuilder: AnyObservableListBuilder?

    public var contextModifier: WidgetContextModifier?
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
    }

    public init<Item>(_ builder: ObservableListBuilder<Item>) {
        self.widgets = []
        self.widgetsBuilder = AnyObservableListBuilder(builder)
     }

    public func build(with context: WidgetContext) -> UIView {
        
        let stack = WidgetPrivateStackView()
        let context = (contextModifier?(context) ?? context).set(view: stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.insetsLayoutMarginsFromSafeArea = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem

        if let insets = padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = insets
        }

        for widget in widgets {
            stack.addArrangedSubview(widget.build(with: context))
        }

        if let builder = widgetsBuilder {
            stack.subscribe(to: builder, with: context)
        }

        modifiers?.apply(to: stack, with: context)

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

internal class WidgetPrivateStackView: UIStackView {

    var disposeBag: DisposeBag!

    public func subscribe(to builder: AnyObservableListBuilder, with context: WidgetContext) {
        builder.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (items) in
                guard let self = self else { return }

                self.disposeBag = DisposeBag()

                self.subviews.forEach {
                    $0.removeFromSuperview()
                }

                var context = context
                context.disposeBag = self.disposeBag

                items.forEach { item in
                    if let widget = builder.widget(for: item) {
                        let view = widget.build(with: context)
                        self.addArrangedSubview(view)
                    }
                }

                UIView.animate(withDuration: 0.01, animations: {
                    self.layoutIfNeeded()
                })
            })
            .disposed(by: context.disposeBag)
    }

}
