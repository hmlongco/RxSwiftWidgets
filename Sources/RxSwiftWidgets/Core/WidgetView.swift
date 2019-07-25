//
//  WidgetView.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/16/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol WidgetView: Widget {
    func widget(_ context: WidgetContext) -> Widget
}

public extension WidgetView {
    func build(with context: WidgetContext) -> UIView {
        return widget(context).build(with: context)
    }
}
