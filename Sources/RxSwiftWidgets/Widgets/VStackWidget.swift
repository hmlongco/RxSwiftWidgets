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
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "VStackWidget()" }

    public var widgets: [Widget]
    public var modifiers = WidgetModifiers()

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
    }

    public init<Item, O:ObservableElement>(_ items: O, builder: @escaping (_ item: Item) -> Widget) where O.Element == [Item] {
        self.modifiers.binding = WidgetModifierBlock<WidgetPrivateStackView> { (stack, context) in
            let items = items.map { $0.map { builder($0) } }
            stack.subscribe(to: items, with: context)
        }
        self.widgets = []
    }

    public func build(with context: WidgetContext) -> UIView {
        
        let stack = WidgetPrivateStackView()
        let context = modifiers.modified(context, for: stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.insetsLayoutMarginsFromSafeArea = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem

        if let insets = modifiers.padding {
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = insets
        }

        for widget in widgets {
            stack.addArrangedSubview(widget.build(with: context))
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

internal class WidgetPrivateStackView: UIStackView {

    var disposeBag: DisposeBag!

    public func subscribe(to observable: Observable<[Widget]>, with context: WidgetContext) {
        observable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (widgets) in
                guard let self = self else { return }

                self.disposeBag = DisposeBag()

                self.subviews.forEach {
                    $0.removeFromSuperview()
                }

                var context = context
                context.disposeBag = self.disposeBag

                widgets.forEach { widget in
                    let view = widget.build(with: context)
                    self.addArrangedSubview(view)
                }

                UIView.animate(withDuration: 0.01, animations: {
                    self.layoutIfNeeded()
                })
            })
            .disposed(by: context.disposeBag)
    }

}
