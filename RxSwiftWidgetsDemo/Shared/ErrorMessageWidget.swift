//
//  ErrorMessageWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 9/7/19.
//

import UIKit
import RxSwiftWidgets

struct ErrorMessageWidget: WidgetView {

    @Binding var message: String

    func widget(_ context: WidgetContext) -> Widget {
        LabelWidget()
            .backgroundColor(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8))
            .color(.white)
            .padding(h:30, v: 20)
            .numberOfLines(0)
            .hidden(true)
            .onEvent($message) { (value, context) in
                guard let label = context.view as? UILabel else {
                    return
                }
                if label.isHidden && value.isEmpty {
                    return
                }
                let baseAnimation = { (_ value: String) in
                    label.text = value
                    label.isHidden = value.isEmpty
                    label.superview?.layoutIfNeeded()
                }
                if label.isHidden {
                    UIView.animate(withDuration: 0.3) {
                        baseAnimation(value)
                    }
                } else {
                    UIView.animate(withDuration: 0.1, animations: {
                        baseAnimation("")
                    }) { (completed) in
                        if completed && !value.isEmpty {
                            UIView.animate(withDuration: 0.3) {
                                baseAnimation(value)
                            }
                        }
                    }
                }
            }
    }
}
