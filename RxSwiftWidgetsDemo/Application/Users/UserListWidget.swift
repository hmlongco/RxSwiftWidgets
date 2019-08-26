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

    @State var users: [User] = User.users

    func widget(_ context: WidgetContext) -> Widget {

        TableWidget([
            DynamicTableSectionWidget($users) {
                TableCellWidget($0.name)
                    .accessoryType(.disclosureIndicator)
                }
                .onSelect { (context, path, user) in
                    context.navigator?.push(widget: UserDetailsWidget(user: user))
                    context.tableView?.deselectRow(at: path, animated: true)
                }
            ]) // TableWidget
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
