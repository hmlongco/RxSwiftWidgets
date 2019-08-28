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

}

extension WidgetTheme {
    public static var defaultTheme: WidgetTheme = {
        let color = WidgetTheme.Color(
            accent: .systemBlue,
            link: .systemBlue,
            text: .darkText,
            secondaryText: .systemGray
        )
        let font = WidgetTheme.Font(
            body: UIFont.preferredFont(forTextStyle: .body)
        )
        return WidgetTheme(color: color, font: font)
    }()
}
