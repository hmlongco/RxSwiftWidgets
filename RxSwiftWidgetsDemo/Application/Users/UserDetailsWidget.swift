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
                        UserPhotoWidget(initials: user.initials, size: 80),
                        LabelWidget(user.name)
                            .font(.title1)
                            .color(.red)
                        ]) // HStackWidget
                        .position(.centerHorizontally)
                    ), // ContainerWidget

                DetailsSectionWidget(widgets: [
                    DetailsNameValueWidget(name: "Address", value: user.address),
                    DetailsNameValueWidget(name: "City", value: user.city),
                    DetailsNameValueWidget(name: "State", value: user.state),
                    DetailsNameValueWidget(name: "Zip", value: user.zip),
                    ]),

                DetailsSectionWidget(widgets: [
                    DetailsNameValueWidget(name: "Email", value: user.email),
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

}

struct UserPhotoWidget: WidgetView {

    var initials: String?
    var size: CGFloat

    func widget(_ context: WidgetContext) -> Widget {
        ZStackWidget([
            LabelWidget(initials)
                .font(.title1)
                .alignment(.center)
                .backgroundColor(.gray)
                .color(.white),
            ImageWidget(named: "User-\(initials ?? "")")
            ])
            .height(size)
            .width(size)
            .cornerRadius(size/2)
    }

}

fileprivate struct DetailsSectionWidget: WidgetView {

    var widgets: [Widget]

    func widget(_ context: WidgetContext) -> Widget {
        ContainerWidget(
                VStackWidget(widgets)
                    .spacing(2)
            )
            .backgroundColor(.secondarySystemBackground)
            .cornerRadius(10)
            .padding(h: 20, v: 15)
    }

}

fileprivate struct DetailsNameValueWidget: WidgetView {

    var name: String?
    var value: String?

    func widget(_ context: WidgetContext) -> Widget {
        HStackWidget([
            LabelWidget(name)
                .color(.gray),
            SpacerWidget(),
            LabelWidget(value)
        ])
    }

}
