//
//  UIColor+Widgets.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 9/10/19.
//

import UIKit

extension UIColor {

    public class var semanticSystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return .white
    }

}
