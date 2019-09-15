
import UIKit
import RxSwiftWidgets

struct DemoDismissibleWidget: WidgetView {

    let desc = """
        Demonstrates launching a dismissible widget and returning a value or simply dismissing (cancelling) the screen programatically.

        This screen will also automatically timeout and return after 8 seconds.
        """

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

                LabelWidget(desc)
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.white)
                    .numberOfLines(0)
                    .padding(h: 0, v: 15),

                ButtonWidget("Return Random Number")
                    .color(.orange)
                    .onTap { context in
                        context.navigator?.dismiss(returning: "\(Int.random(in: 1..<1000))")
                    },

                ButtonWidget("Dismiss")
                    .color(.orange)
                    .onTap { context in
                        context.navigator?.dismiss()
                    },

                SpacerWidget(),

                BackButtonWidget(text: "Done"),

                ]) // VStackWidget
                .spacing(15)
                .padding(h: 40, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Dismissible Demo", hidden: true)
            .safeArea(false)
            .onViewDidAppear { (context) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    context.navigator?.dismiss(returning: "Automactic Return")
                }
            }
        }

}
