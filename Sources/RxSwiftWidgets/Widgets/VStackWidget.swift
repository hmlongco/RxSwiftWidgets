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

    public let widgets: [Widget]

    public var contextModifier: WidgetContextModifier?
    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
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

        modifiers?.apply(to: stack, with: context)

        return stack
    }

    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        return modified(WidgetModifier(keyPath: \UIStackView.alignment, value: alignment))
    }

    public func bind<Item, O:ObservableElement>(_ observable: O, transform: @escaping (_ item: Item) -> Widget) -> Self where O.Element == [Item] {
        return bind(observable.asObservable().map { $0.map { transform($0) } })
    }


    public func bind<O:ObservableElement>(_ observable: O) -> Self where O.Element == [Widget] {
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

internal class WidgetPrivateStackView: UIStackView {

    var disposeBag: DisposeBag!

    public func subscribe(to widgets: Observable<[Widget]>, with context: WidgetContext) {
        widgets
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
