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
    , WidgetPadding {

    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    public init(_ text: String? = nil, for state: UIControl.State = .normal) {
        if let text = text {
            modifiers = [WidgetModifierBlock<UIButton> { button, _ in
                button.setTitle(text, for: state)
            }]
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.contentEdgeInsets = padding ?? button.contentEdgeInsets
        button.backgroundColor = .clear

        modifiers?.apply(to: button, with: context)
        
        return button
    }

    public func alignment(_ alignment: NSTextAlignment) -> Self {
        return modified(WidgetModifierBlock<UIButton> { button, _ in
            button.titleLabel?.textAlignment = alignment
        })
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

    public func onTap(_ tapped: @escaping (WidgetContext) -> Void) -> Self {
        return modified(WidgetModifierBlock<UIButton>({ (button, context) in
            button.rx.tap
                .subscribe(onNext: { _ in
                    tapped(context)
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
