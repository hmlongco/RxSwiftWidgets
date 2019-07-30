//
//  DemoBindingWidget.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 7/30/19.
//

import UIKit
import RxSwiftWidgets

struct DemoBindingWidget: WidgetView {

    @Binding var title: String

    let desc = """
        Demonstrates binding object properties in and across Widgets using @State and @Binding values.
        """

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStackWidget([

                LabelWidget("Binding Sample")
                    .font(.title1)
                    .color(.white)
                    .alignment(.center),

                LabelWidget(desc)
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.white)
                    .numberOfLines(0)
                    .padding(h: 0, v: 15),

                LabelWidget()
                    .text($title.asObservable().map { "Parent's page title is '\($0)'."} )
                    .font(.preferredFont(forTextStyle: .callout))
                    .alignment(.center)
                    .color(.white)
                    .numberOfLines(0)
                    .padding(h: 0, v: 8),

                ButtonWidget("Update Choice 1")
                    .color(.orange)
                    .onTap { context in
                        self.title = "Features - Choice 1"
                    },

                ButtonWidget("Update Choice 2")
                    .color(.orange)
                    .onTap { context in
                        self.title = "Features - Choice 2"
                    },

                SpacerWidget(),

                DoneButtonWidget(),

                ]) // VStackWidget
                .spacing(15)
                .padding(h: 40, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Binding Demo", hidden: true)
            .safeArea(false)
        }

}
