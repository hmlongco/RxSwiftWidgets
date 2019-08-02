//
//  Fonts.swift
//
//  Created by Michael Long on 4/17/18.
//

import UIKit

extension UIFont {

    static let body = UIFont.preferredFont(forTextStyle: .body)
    static let callout = UIFont.preferredFont(forTextStyle: .callout)
    static let caption1 = UIFont.preferredFont(forTextStyle: .caption1)
    static let caption2 = UIFont.preferredFont(forTextStyle: .caption2)
    static let error = UIFont.preferredFont(forTextStyle: .footnote)
    static let footnote = UIFont.preferredFont(forTextStyle: .footnote)
    static let headline = UIFont.preferredFont(forTextStyle: .headline)
    static let text = UIFont.preferredFont(forTextStyle: .body)
    static let title1 = UIFont.preferredFont(forTextStyle: .title1)
    static let title2 = UIFont.preferredFont(forTextStyle: .title2)
    static let title3 = UIFont.preferredFont(forTextStyle: .title3)

}

extension UIFont {

    private func withTraits(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont? {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
            return nil
        }

        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont? {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont? {
        return withTraits(traits: .traitItalic)
    }

    func boldItalic() -> UIFont? {
        return withTraits(traits: .traitBold, .traitItalic)
    }

    func condensed() -> UIFont? {
        return withTraits(traits: .traitCondensed)
    }

    func expanded() -> UIFont? {
        return withTraits(traits: .traitExpanded)
    }

    func tightLeading() -> UIFont? {
        return withTraits(traits: .traitTightLeading)
    }

    func looseLeading() -> UIFont? {
        return withTraits(traits: .traitLooseLeading)
    }

}
