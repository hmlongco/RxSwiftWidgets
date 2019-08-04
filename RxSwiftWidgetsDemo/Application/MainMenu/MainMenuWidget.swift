
import UIKit
import RxSwiftWidgets

struct MainMenuWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStack([

            Image(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStack([

                Container(
                    HStack([
                        Image(named: "RxSwiftWidgets-Logo-DK")
                            .height(100)
                            .width(100)
                            .contentMode(.scaleAspectFit),
                        Text("RxSwiftWidgets")
                            .font(.title2)
                            .color(.white)
                        ])
                        .position(.centerHorizontally)
                    ),

                MainMenuItemWidget(text: "Account Details", onTap: { context in
                    context.navigator?.push(widget: AccountDetailsWidget())
                }),

                MainMenuItemWidget(text: "Features", onTap: { context in
                    context.navigator?.push(widget: FeaturesWidget())
                }),
                
                Spacer(),

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
