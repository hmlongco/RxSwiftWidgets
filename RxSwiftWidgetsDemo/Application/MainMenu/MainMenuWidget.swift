
import UIKit
import RxSwiftWidgets

struct MainMenuWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStackWidget([

                ContainerWidget(
                    HStackWidget([
                        ImageWidget(named: "RxSwiftWidgets-Logo-DK")
                            .height(100)
                            .width(100)
                            .contentMode(.scaleAspectFit),
                        LabelWidget("RxSwiftWidgets")
                            .font(.title2)
                            .color(.white)
                        ])
                        .position(.centerHorizontally)
                    ),

                MainMenuItemWidget(text: "Sample Widget") { context in
                    context.navigator?.push(widget: SampleWidget())
                },
                MainMenuItemWidget(text: "Dismissible Sample") { context in
                    context.navigator?.push(widget: DemoDismissibleWidget(), onDismiss: { (value: String) in
                        print(value)
                    })
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
        }
}
