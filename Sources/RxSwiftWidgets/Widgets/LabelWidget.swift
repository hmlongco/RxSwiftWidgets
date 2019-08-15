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


public struct LabelWidget
    : WidgetViewModifying
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "LabelWidget()" }

    public var modifiers = WidgetModifiers()

    /// Sets label text on initialization
    public init(_ text: String? = nil) {
        modifiers.binding = WidgetModifier(keyPath: \UILabel.text, value: text)
    }

    /// Allows initialization of label text with ObservableElement
    public init<O:ObservableElement>(_ observable: O) where O.Element == String {
        modifiers.binding = WidgetModifierBlock<UILabel> { label, context in
            observable.asObservable().bind(to: label.rx.text).disposed(by: context.disposeBag)
        }
    }

    /// Allows initialization of label text with ObservableElement
    public init<O:ObservableElement>(_ observable: O) where O.Element == String? {
        modifiers.binding = WidgetModifierBlock<UILabel> { label, context in
            observable.asObservable().bind(to: label.rx.text).disposed(by: context.disposeBag)
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        let label = WidgetLabel()
        let context = modifiers.modified(context, for: label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textInsets = modifiers.padding
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        modifiers.apply(to: label, with: context)
        
        return label
    }

    /// Sets alignment of label text
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.textAlignment, value: alignment))
    }

    /// Sets color of label text
    public func color(_ color: UIColor) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.textColor, value: color))
    }

    /// Sets font of label text
    public func font(_ font: UIFont) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.font, value: font))
    }

    /// Sets lineBreakMode for label text
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.lineBreakMode, value: lineBreakMode))
    }

    /// Sets number of lines of label text
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.numberOfLines, value: numberOfLines))
    }

    /// Placeholder text
    public func placeholder(_ text: String) -> Self {
        return modified(WidgetModifier(keyPath: \UILabel.text, value: text))
    }

    /// Allows modification of generated label
    public func with(_ block: @escaping WidgetModifierBlockType<UILabel>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
}

extension LabelWidget {
    public static func footnote(_ text: String) -> LabelWidget {
        return LabelWidget(text)
            .color(.lightGray)
            .numberOfLines(0)
            .font(.preferredFont(forTextStyle: .footnote))
    }
}

fileprivate class WidgetLabel: UILabel {
    var textInsets: UIEdgeInsets? {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let textInsets = textInsets else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        guard let textInsets = textInsets else {
            super.drawText(in: rect)
            return
        }
        super.drawText(in: rect.inset(by: textInsets))
    }
}
