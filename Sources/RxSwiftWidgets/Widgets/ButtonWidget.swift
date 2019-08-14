//
//  ButtonWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public struct ButtonWidget
    : WidgetViewModifying
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ButtonWidget()" }

    public var modifiers = WidgetModifiers()

    public init(_ text: String? = nil, for state: UIControl.State = .normal) {
        if let text = text {
            modifiers.binding = WidgetModifierBlock<UIButton> { button, _ in
                button.setTitle(text, for: state)
            }
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        
        let button = UIButton()
        let context = context.set(view: button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.contentEdgeInsets = modifiers.padding ?? button.contentEdgeInsets
        button.backgroundColor = .clear
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        modifiers.apply(to: button, with: context)
        
        return button
    }

    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        return modified(WidgetModifier(keyPath: \UIButton.contentHorizontalAlignment, value: alignment))
    }

    public func color(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        return modified(WidgetModifierBlock<UIButton> { button, _ in
            button.setTitleColor(color, for: state)
        })
    }

    public func font(_ font: UIFont) -> Self {
        return modified(WidgetModifierBlock<UIButton> { button, _ in
            button.titleLabel?.font = font
        })
    }

    public func onTap(effect: WidgetTapEffectType? = WidgetTapEffectDim(), handler: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock<UIButton>({ (button, context) in
            button.rx.tap
                .subscribe(onNext: { _ in
                    if let effect = effect {
                        effect.animate(button) {
                            handler(context)
                        }
                    } else {
                        handler(context)
                    }
                })
                .disposed(by: context.disposeBag)
        }))
    }

    public func text(_ text: String?, for state: UIControl.State = .normal) -> Self {
        return modified(WidgetModifierBlock<UIButton> { button, _ in
            button.setTitle(text, for: state)
        })
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIButton>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}
