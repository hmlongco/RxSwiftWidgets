
import UIKit
import RxSwiftWidgets

struct MainMenuWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            ScrollWidget(
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

                    MainMenuItemWidget(text: "Account Details", onTap: { context in
                        context.navigator?.push(widget: AccountDetailsWidget())
                    }),

                    MainMenuItemWidget(text: "Login Form", onTap: { context in
                        context.navigator?.push(widget: LoginFormWidget())
                    }),

                    MainMenuItemWidget(text: "Features", onTap: { context in
                        context.navigator?.push(widget: FeaturesWidget())
                    }),

                    ]) // VStackWidget
                    .spacing(15)
                    .padding(h: 30, v: 50)
                    .safeArea(true)
                ) // ScrollWidget
                .safeArea(false),

            LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
                .alignment(.center)
                .backgroundColor(UIColor(white: 0.0, alpha: 0.4))
                .padding(h: 20, v: 20)
                .position(.bottom)
                .safeArea(true),

            ]) // ZStackWidget
            .navigationBar(title: "Menu", hidden: true)
            .safeArea(false)
        }
}
