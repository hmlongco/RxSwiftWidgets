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

        TableWidget([
            TableSectionWidget([
                VStackWidget([
                    LabelWidget("This is line 1"),
                    LabelWidget("This is a footnote for line 1")
                        .font(.footnote)
                    ])
                    .spacing(2),
                TableCellWidget("This is line 2", subtitle: "This is a subtitle"),
                TableCellWidget("Name", value: "Value"),
                ]),
            TableSectionWidget([
                HStackWidget([
                    LabelWidget("On or Off"),
                    SpacerWidget(),
                    UIControlWidget(UISwitch())
                        .with({ (view, context) in
                            view.onTintColor = context.theme.color.accent
                        })
                    ])
                ]),
            TableSectionWidget([
                LabelWidget("This is label line 1"),
                TableCellWidget("This is row line 2"),
                ]),
            ]) // TableWidget
            .navigationBar(title: "Static TableView", hidden: false)
            .safeArea(true)
            .onSelect { (context, path) in
                context.tableView?.deselectRow(at: path, animated: true)
            }
            .onViewDidAppear { _ in

            }
            .theme {
                $0.color.text = $0.color.accent
            }

    }

}
