//
//  WidgetTheme.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 8/26/19.
//

import UIKit

extension WidgetContext {

    public var theme: WidgetTheme {
        if let theme = find(WidgetTheme.self) {
            return theme
        }
        return WidgetTheme.defaultTheme
    }

    public func set(theme: WidgetTheme) -> WidgetContext {
        return put(theme as WidgetTheme)
    }

}

public struct WidgetTheme {

    public struct Color {

        public var accent: UIColor
        public var link: UIColor

        public var text: UIColor
        public var secondaryText: UIColor

    }

    public struct Font {
        public var body: UIFont
    }

    public var color: Color
    public var font: Font

    public mutating func update(_ updater: @escaping (_ theme: inout WidgetTheme) -> Void) {
        updater(&self)
    }

}

extension WidgetTheme {

    public static var defaultTheme: WidgetTheme = {
        if #available(iOS 13, *) {
            let color = WidgetTheme.Color(
                accent: .systemBlue,
                link: .systemBlue,
                text: .label,
                secondaryText: .secondaryLabel
            )
            let font = WidgetTheme.Font(
                body: UIFont.preferredFont(forTextStyle: .body)
            )
            return WidgetTheme(color: color, font: font)
        } else {
            let color = WidgetTheme.Color(
                accent: .blue,
                link: .blue,
                text: .darkText,
                secondaryText: .gray
            )
            let font = WidgetTheme.Font(
                body: UIFont.preferredFont(forTextStyle: .body)
            )
            return WidgetTheme(color: color, font: font)
        }
    }()
    
}

extension WidgetViewModifying {

    public func theme(_ theme: WidgetTheme) -> Self {
        let modifier: WidgetContextModifier = { $0.set(theme: theme) }
        return modified { $0.modifiers.contextModifier = modifier }
    }

    public func theme(_ update: @escaping (_ theme: inout WidgetTheme) -> Void) -> Self {
        let modifier: WidgetContextModifier = { context in
            var theme = context.theme
            update(&theme)
            return context.set(theme: theme)
        }
        return modified { $0.modifiers.contextModifier = modifier }
    }

}
