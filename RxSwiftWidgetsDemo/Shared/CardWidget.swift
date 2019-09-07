//
//  CardWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 9/1/19.
//

import UIKit
import RxSwiftWidgets

struct CardWidget: WidgetView {

    let widget: Widget

    func widget(_ context: WidgetContext) -> Widget {
        ContainerWidget(widget)
            .padding(h: 20, v: 15)
            .cornerRadius(20)
            .backgroundColor(UIColor(white: 0.5, alpha: 0.15))
    }

}
