//
//  DemoStaticTableViewWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 8/16/19.
//

import UIKit
import RxSwift
import RxSwiftWidgets

struct DemoStaticTableViewWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        TableViewWidget([
            SectionWidget([
                VStackWidget([
                    LabelWidget("This is line 1"),
                    LabelWidget("This is a footnote for line 1")
                        .font(.footnote)
                    ])
                    .spacing(2),
                RowWidget("This is line 2", subtitle: "This is a subtitle"),
                ]),
            SectionWidget([
                HStackWidget([
                    LabelWidget("On or Off"),
                    SpacerWidget(),
                    UIControlWidget(UISwitch())
                    ])
                ]),
            SectionWidget([
                LabelWidget("This is label line 1"),
                RowWidget("This is row line 2"),
                ]),
            ]) // TableViewWidget
            .navigationBar(title: "Static TableView", hidden: false)
            .safeArea(true)
            .onViewDidAppear { _ in

            }
        
    }

}
