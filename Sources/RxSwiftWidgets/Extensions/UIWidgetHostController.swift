//
//  UIViewController+Widgets.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class UIWidgetHostController: UIViewController {

    public var widget: Widget!
    public var context: WidgetContext!

    // lifecycle

    public init(_ widget: Widget, with context: WidgetContext? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.widget = widget
        self.context = (context?.new() ?? WidgetContext())
            .set(viewController: self)
    }

    public init(_ widget: Widget, with context: WidgetContext, dismissible: WidgetDismissibleType) {
        super.init(nibName: nil, bundle: nil)
        self.widget = widget
        self.context = context.new()
            .set(viewController: self)
            .set(dismissible: dismissible)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEINIT UIWidgetViewController")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        build()
    }

    public func build() {
        view.build(widget: widget, with: context)
    }

    public func rebuild() {
        context = context.new()
        build()
    }

}

extension WidgetContext {

    public func rebuild() {
        (self.viewController as? UIWidgetHostController)?.rebuild()
    }

}
