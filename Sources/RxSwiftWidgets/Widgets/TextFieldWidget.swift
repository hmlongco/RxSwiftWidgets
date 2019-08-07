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
    : WidgetViewModifying
//    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "TextFieldWidget()" }

    public var modifiers: WidgetModifiers?
//    public var padding: UIEdgeInsets?

    /// Sets label text on initialization
//    public init(_ text: String? = nil) {
//        self.text = text
//    }

    public func build(with context: WidgetContext) -> UIView {
        let textField = WidgetTextField()
        let context = context.set(view: textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .body)
//        textField.text = text
//        label.textInsets = padding
        textField.backgroundColor = .clear

        modifiers?.apply(to: textField, with: context)
        
        return textField
    }

    /// Sets alignment of label text
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.textAlignment, value: alignment))
    }

    /// Sets color of label text
    public func color(_ color: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.textColor, value: color))
    }

    /// Sets font of label text
    public func font(_ font: UIFont) -> Self {
        return modified(WidgetModifier(keyPath: \UITextField.font, value: font))
    }

    /// Sets label text
//    public func text(_ text: String?) -> Self {
//        return modified { $0.text = text }
//    }

    /// Allows modification of generated label
    public func with(_ block: @escaping WidgetModifierBlockType<UITextField>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}

extension TextFieldWidget {

//    /// Allows initialization of label text with ObservableElement
//    public init<O:ObservableElement>(_ observable: O) where O.Element == String {
//        self.modifiers = [modifier(for: observable)]
//    }
//
//    /// Allows initialization of label text with ObservableElement
//    public init<O:ObservableElement>(_ observable: O) where O.Element == String? {
//        self.modifiers = [modifier(for: observable)]
//    }
//
//    /// Dynamically sets label text from ObservableElement
//    public func text<O:ObservableElement>(_ observable: O) -> Self where O.Element == String {
//        return modified(modifier(for: observable))
//    }
//
//    /// Dynamically sets label text from ObservableElement
//    public func text<O:ObservableElement>(_ observable: O) -> Self where O.Element == String? {
//        return modified(modifier(for: observable))
//    }
//
//    internal func modifier<O:ObservableElement>(for observable: O) -> AnyWidgetModifier where O.Element == String {
//        WidgetModifierBlock<UILabel> { label, context in
//            observable.asObservable().bind(to: label.rx.text).disposed(by: context.disposeBag)
//        }
//    }
//
//    internal func modifier<O:ObservableElement>(for observable: O) -> AnyWidgetModifier where O.Element == String? {
//        WidgetModifierBlock<UILabel> { label, context in
//            observable.asObservable().bind(to: label.rx.text).disposed(by: context.disposeBag)
//        }
//    }

}

fileprivate class WidgetTextField: UITextField {

}
