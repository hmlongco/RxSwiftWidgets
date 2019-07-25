//
//  Styles.swift
//  FNB-Beta
//
//  Created by Michael Long on 4/17/18.
//  Copyright © 2018 First National Bank. All rights reserved.
//

import UIKit

extension AppDelegate {

    func configureStyles() {
        window?.tintColor = .brand
        setupControlStyles()
        setupLabelStyles()
        setupNavigationStyles()
    }

    private func setupControlStyles() {
        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self]).tintColor = .brand
        UITextField.appearance().textColor = .darkText
        UITextField.appearance().tintColor = .gray
        UISwitch.appearance().onTintColor = .brand
    }

    private func setupLabelStyles() {
//        BrandLabel.appearance().textColor = .brand
//        DarkBrandLabel.appearance().textColor = .darkBrand
//        BrandFootnoteLabel.appearance().font = .footnote
//        BrandFootnoteLabel.appearance().textColor = .brand
//        DarkBrandFootnoteLabel.appearance().font = .footnote
//        DarkBrandFootnoteLabel.appearance().textColor = .darkBrand
//        ErrorLabel.appearance().font = .footnote
//        ErrorLabel.appearance().textColor = .error
//        FootnoteLabel.appearance().font = .footnote
//        FootnoteLabel.appearance().textColor = .disabledGrayHex
//        DarkFootnoteLabel.appearance().font = .footnote
//        DarkFootnoteLabel.appearance().textColor = .disabledGrayHex
    }

    private func setupNavigationStyles() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }

}
