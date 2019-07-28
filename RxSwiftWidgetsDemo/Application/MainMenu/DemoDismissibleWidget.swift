
import UIKit
import RxSwiftWidgets

struct DemoDismissibleWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStackWidget([

                LabelWidget("Dismissible Sample")
                    .font(.title1)
                    .color(.white)
                    .alignment(.center),

                ButtonWidget("Dismiss Returning Value")
                    .color(.orange)
                    .onTap { context in
                        context.navigator?.dismiss(returning: "Return Value")
                    },

                ButtonWidget("Dismiss")
                    .color(.orange)
                    .onTap { context in
                        context.navigator?.dismiss()
                    },

                SpacerWidget(),

                LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
                    .alignment(.center),

                ]) // VStackWidget
                .spacing(12)
                .padding(h: 30, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Main Menu", hidden: true)
            .safeArea(false)
            .onDidAppear { (context) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    context.navigator?.dismiss(returning: "Automactic Return")
                }
            }
        }

}
