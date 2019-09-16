//
//  UserListWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 8/16/19.
//

import UIKit
import RxSwift
import RxSwiftWidgets

class UserListViewModel {

    @State var users: [User] = []

    func reload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.users = User.users
        })
    }

}

struct UserListWidget: WidgetView {

    var viewModel = UserListViewModel()

    func widget(_ context: WidgetContext) -> WidgetViewType {

        TableWidget([
            DynamicTableSectionWidget(viewModel.$users) {
                TableCellWidget(
                    HStackWidget([
                        UserPhotoWidget(initials: $0.initials, size: 35),
                        LabelWidget($0.name)
                    ])
                    )
                    .accessoryType(.disclosureIndicator)
                }
                .onSelect { (context, path, user) in
                    context.navigator?.push(UserDetailsWidget(user: user))
                    context.tableView?.deselectRow(at: path, animated: true)
                }
            ]) // TableWidget
            .onRefresh(initialRefresh: true, handler: { _ in
                self.viewModel.reload()
            })
            .navigationBar(title: "User List", hidden: false)
            .safeArea(false)
        
    }

}
