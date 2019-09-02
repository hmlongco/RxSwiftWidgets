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
                        ]) // HStackWidget
                        .position(.centerHorizontally)
                    ), // ContainerWidget

                CardWidget(widget:
                    VStackWidget([
                        DetailsNameValueWidget(name: "Address", value: user.address),
                        DetailsNameValueWidget(name: "City", value: user.city),
                        DetailsNameValueWidget(name: "State", value: user.state),
                        DetailsNameValueWidget(name: "Zip", value: user.zip),
                        ])
                    ),

                CardWidget(widget:
                    VStackWidget([
                        DetailsNameValueWidget(name: "Email", value: user.email),
                        ])
                    ),

                SpacerWidget()
                ]) // VStackWidget
                .spacing(20)

            ) // ScrollWidget
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
                .font(size > 40 ? .title1 : .body)
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
