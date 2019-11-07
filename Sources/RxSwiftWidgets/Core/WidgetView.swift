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

    func build(_ widget: Widget, with context: WidgetContext) -> UIView

}

extension WidgetView {

    /// Implement this function to hook into the standard build process and perform addtional processing on the passed context
    /// before the view is built or to add additional processing onto the generated UIView.
    ///
    /// Default implementation delegates to build(:Widget:Context) function below.
    ///
    public func build(with context: WidgetContext) -> UIView {
        return build(widget(context), with: context)
    }

    /// Performs the actual build on the widget provided by WidgetView.
    public func build(_ widget: Widget, with context: WidgetContext) -> UIView {
        let view = widget.build(with: context)
        if let modifying = self as? WidgetModifying {
            let context = modifying.modifiers.modified(context, for: view)
            modifying.modifiers.apply(to: view, with: context)
        }
        return view
    }

}
