//
//  CardWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 9/1/19.
//

import UIKit
import RxSwiftWidgets

struct CardWidget: WidgetView {

    let widget: WidgetViewType

    func widget(_ context: WidgetContext) -> WidgetViewType {
        ContainerWidget(widget)
            .padding(h: 20, v: 15)
            .cornerRadius(10)
            .backgroundColor(UIColor(white: 0.5, alpha: 0.15))
    }

}
