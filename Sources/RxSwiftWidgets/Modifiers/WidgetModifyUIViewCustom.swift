//
//  WidgetUIViewModifiersCustom.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK:- UIView Widget Properties

extension WidgetViewModifying {

    public func safeArea(_ value: Bool) -> Self {
        return modified(WidgetModifier(keyPath: \UIView.widget.safeArea, value: value))
    }

    public func with<View:UIView>(_ block: @escaping WidgetModifierBlockType<View>) -> Self {
        return modified(WidgetModifierBlock(block))
    }
    
}
