//
//  UIViewController+Widgets.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/23/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class UIWidgetHostController: UIViewController {

    public var context: WidgetContext?
    public var widget: Widget?

    public init(_ widget: Widget? = nil, context: WidgetContext? = nil) {
        self.context = context
        self.widget = widget
        super.init(nibName: nil, bundle: nil)
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
        context = context?.new(for: self) ?? WidgetContext(self)
        if let widget = widget {
            view.build(widget: widget, with: context!)
        }
    }

}
