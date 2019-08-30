//
//  WidgetView.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/16/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol WidgetView: Widget {

    func widget(_ context: WidgetContext) -> Widget

    func onBuild(_ context: WidgetContext)

}

extension WidgetView {

    public func build(with context: WidgetContext) -> UIView {
        let widget = self.widget(context)
        let view = widget.build(with: context)
        if let modifying = self as? WidgetModifying {
            let context = modifying.modifiers.modified(context, for: view)
            modifying.modifiers.apply(to: view, with: context)
            onBuild(context)
        } else {
            onBuild(context.set(view: view))
        }
        return view
    }

    public func onBuild(_ context: WidgetContext) { }

}
