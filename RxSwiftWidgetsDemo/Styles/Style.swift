//
//  Defaults.swift
//  Widgets
//
//  Created by Michael Long on 3/18/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

class Style {
    static var shared: StyleProviding = DefaultStyle()
}

protocol StyleProviding {

    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }

    var navigationColor: UIColor { get }
    var backgroundColor: UIColor { get }

    var textColor: UIColor { get }
    var textFont: UIFont { get }

    var sectionBackgroundColor: UIColor { get }

}

class DefaultStyle: StyleProviding {

    lazy var primaryColor: UIColor = .red
    lazy var secondaryColor: UIColor = .gray

    lazy var navigationColor: UIColor = primaryColor
    lazy var backgroundColor: UIColor = .white

    lazy var textColor: UIColor = .darkText
    lazy var textFont: UIFont = .preferredFont(forTextStyle: .callout)

    lazy var sectionBackgroundColor: UIColor = UIColor(white: 0.9, alpha: 1.0)

}

class DarkStyle: StyleProviding {

    lazy var primaryColor: UIColor = .red
    lazy var secondaryColor: UIColor = .gray

    lazy var navigationColor: UIColor = primaryColor
    lazy var backgroundColor: UIColor = UIColor(white: 0, alpha: 1.0)

    lazy var textColor: UIColor = .lightText
    lazy var textFont: UIFont = .preferredFont(forTextStyle: .callout)

    lazy var sectionBackgroundColor: UIColor = UIColor(white: 0.2, alpha: 1.0)

}

