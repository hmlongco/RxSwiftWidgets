//
//  AlertWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 9/15/19.
//

import UIKit

public protocol WidgetController: WidgetControllerType {
    func build(with context: WidgetContext) -> UIViewController
}

public struct AlertWidget: WidgetController {

    internal let title: String?
    internal let message: String?

    internal var actions: [WidgetAlertAction] = []

    public init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }

    public func build(with context: WidgetContext) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let context = context.set(viewController: alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                action.handler?(context)
            }))
        }
        return alert
    }

    public func addAction(title: String?, style: UIAlertAction.Style = .default, handler: ((_ context: WidgetContext) -> Void)? = nil) -> Self {
        var widget = self
        widget.actions.append(WidgetAlertAction(title: title, style: style, handler: handler))
        return widget
    }

}

internal struct WidgetAlertAction {
    let title: String?
    let style: UIAlertAction.Style
    let handler: ((_ context: WidgetContext) -> Void)?
}
