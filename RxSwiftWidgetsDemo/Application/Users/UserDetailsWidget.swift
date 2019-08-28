//
//  UserDetailsWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 8/16/19.
//

import UIKit
import RxSwift
import RxSwiftWidgets

struct UserDetailsWidget: WidgetView {

    var user: User

    func widget(_ context: WidgetContext) -> Widget {

        ScrollWidget(
            VStackWidget([

                ContainerWidget(
                    HStackWidget([
                        ZStackWidget([
                            LabelWidget(user.initials)
                                .font(.title1)
                                .alignment(.center)
                                .backgroundColor(.gray)
                                .color(.white),
                            ImageWidget(named: "User-\(user.initials ?? "")")
                            ])
                            .height(80)
                            .width(80)
                            .cornerRadius(40),
                        LabelWidget(user.name)
                            .font(.title1)
                            .color(.red)
                        ]) // HStackWidget
                        .position(.centerHorizontally)
                    ), // ContainerWidget

                sectionWidget([
                    nameValueWidget(name: "Address", value: user.address),
                    nameValueWidget(name: "City", value: user.city),
                    nameValueWidget(name: "State", value: user.state),
                    nameValueWidget(name: "Zip", value: user.zip),
                    ]),

                sectionWidget([
                    nameValueWidget(name: "Email", value: user.email),
                    ]),

                SpacerWidget()
                ]) // VStackWidget
                .spacing(20)
            ) // ContainerWidget
            .backgroundColor(.systemBackground)
            .safeArea(false)
            .padding(20)
            .navigationBar(title: "User Information", hidden: false)

    }

    func sectionWidget(_ widgets: [Widget]) -> Widget {
        return ContainerWidget(
                VStackWidget(widgets)
                    .spacing(2)
            )
            .backgroundColor(.secondarySystemBackground)
            .cornerRadius(10)
            .padding(h: 20, v: 15)
    }

    func nameValueWidget(name: String, value: String?) -> Widget {
        return HStackWidget([
            LabelWidget(name)
                .color(.gray),
            SpacerWidget(),
            LabelWidget(value)
        ])
    }

}
