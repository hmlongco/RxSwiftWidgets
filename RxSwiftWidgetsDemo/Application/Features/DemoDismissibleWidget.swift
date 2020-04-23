
import UIKit
import RxSwiftWidgets

struct DemoDismissibleWidget: WidgetView {

    let desc = """
        Demonstrates launching a dismissible widget and returning a value or simply dismissing (cancelling) the screen programatically.

        If a value is returned it will be shown using an AlertWidget.

        This screen will also automatically timeout after 8 seconds.
        """

    @State var dismissed = false

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget {

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false)

            VStackWidget {

                LabelWidget("Dismissible Sample")
                    .font(.title1)
                    .color(.white)
                    .alignment(.center)

                LabelWidget(desc)
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.white)
                    .numberOfLines(0)
                    .padding(h: 0, v: 15)

                ButtonWidget("Return Random Number")
                    .color(.orange)
                    .onTap { context in
                        self.dismissed = true
                        context.navigator?.dismiss(returning: "\(Int.random(in: 1..<1000))")
                    }

                ButtonWidget("Dismiss")
                    .color(.orange)
                    .onTap { context in
                        self.dismissed = true
                        context.navigator?.dismiss()
                    }

                SpacerWidget()

                BackButtonWidget(text: "Done")

            } // VStackWidget
            .spacing(15)
            .padding(h: 40, v: 50)

        } // ZStackWidget
        .navigationBar(title: "Dismissible Demo", hidden: true)
        .safeArea(false)
        .onViewDidAppear { (context) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                if !self.dismissed {
                    context.navigator?.dismiss()
                }
            }
        }
    }

}
