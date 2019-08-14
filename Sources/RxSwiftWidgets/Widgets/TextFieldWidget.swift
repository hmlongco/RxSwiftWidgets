//
//  LabelWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public struct TextFieldWidget
    : WidgetControlModifying
    , CustomDebugStringConvertible {

    public var debugDescription: String { "TextFieldWidget()" }

    public var bindingModifier: AnyWidgetModifier

    public var modifiers: WidgetModifiers?
    public var padding: UIEdgeInsets?

    /// Sets field text on initialization
    public init<B:BindableElement>(_ bindable: B) where B.Element == String {
        bindingModifier = WidgetModifierBlock<UITextField> { view, context in
            context.disposeBag.insert(
                bindable.asObservable().bind(to: view.rx.text),
                bindable.bidirectionalBind(view.rx.text.orEmpty.asObservable())
            )
        }
    }

    public init<B:BindableElement>(_ bindable: B) where B.Element == String? {
        bindingModifier = WidgetModifierBlock<UITextField> { view, context in
            context.disposeBag.insert(
                bindable.asObservable().bind(to: view.rx.text),
                bindable.bidirectionalBind(view.rx.text.asObservable())
            )
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        let textField = WidgetTextField()
        let context = context.set(view: textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.backgroundColor = .clear

        bindingModifier.apply(to: textField, with: context)
        modifiers?.apply(to: textField, with: context)
        
        return textField
    }

    /// Sets alignment of label text
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.textAlignment, value: alignment))
    }

    /// Sets borderStyle for text field
    public func borderStyle(_ borderStyle: UITextField.BorderStyle) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.borderStyle, value: borderStyle))
    }

    /// Sets color of text field
    public func color(_ color: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.textColor, value: color))
    }

    /// Sets font of text field
    public func font(_ font: UIFont) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.font, value: font))
    }

    /// Sets placeholder for text field
    public func placeholder(_ placeholder: String?) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.placeholder, value: placeholder))
    }

    /// Sets secureTextEntry for text field
    public func secureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.isSecureTextEntry, value: isSecureTextEntry))
    }

    /// Allows modification of generated field
    public func with(_ block: @escaping WidgetModifierBlockType<UITextField>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}

fileprivate class WidgetTextField: UITextField {

}
