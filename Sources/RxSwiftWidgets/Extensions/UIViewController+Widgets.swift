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

public class UIWidgetHostController: UIViewController {

    public var widget: Widget!
    public var context: WidgetContext!

    // lifecycle

    public init(_ widget: Widget, with context: WidgetContext? = nil, dismissible: WidgetDismissibleType? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.widget = widget
        self.context = (context?.new() ?? WidgetContext())
            .set(viewController: self)
            .set(dismissible: dismissible)
    }

    required init?(coder: NSCoder) {
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

}
