//
//  UserListWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 8/16/19.
//

import UIKit
import RxSwift
import RxSwiftWidgets

struct UserListWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        TableViewWidget([
            SectionWidget([
                LabelWidget("This is line 1"),
                LabelWidget("This is line 2")
                ]),
            SectionWidget([
                LabelWidget("This is line 1"),
                LabelWidget("This is line 2")
                ])
            ]) // TableViewWidget
            .navigationBar(title: "User List", hidden: false)
            .safeArea(true)
            .onViewDidAppear { _ in

            }
        
    }

//    func accountDetailsRow(_ detail: AccountInformation.AccountDetails) -> Widget {
//        return HStackWidget([
//            LabelWidget(detail.name)
//                .font(.body)
//                .color(.gray),
//            SpacerWidget(),
//            LabelWidget(detail.value)
//                .color(.darkText),
//            ])
//    }

}
