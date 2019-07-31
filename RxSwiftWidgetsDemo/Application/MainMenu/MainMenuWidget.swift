
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

                MainMenuItemWidget(text: "Features") { context in
                    context.navigator?.push(widget: FeaturesWidget())
                },
                MainMenuItemWidget(text: "Account Details") { context in
                    context.navigator?.push(widget: AccountDetailsWidget())
                },

                SpacerWidget(),

                LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
                    .alignment(.center),

                ]) // VStackWidget
                .spacing(15)
                .padding(h: 30, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Menu", hidden: true)
            .safeArea(false)
        }
}
