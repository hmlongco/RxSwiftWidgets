
import UIKit
import RxSwiftWidgets

struct MainMenuWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            ContainerWidget(

                VStackWidget([

                    ContainerWidget(
                        ImageWidget(named: "RxSwiftWidgets-Logo-DK")
                            .height(120)
                            .width(120)
                            .contentMode(.scaleAspectFit)
                            .position(.centerHorizontally)
                        ),

                    MainMenuItemWidget(text: "Sample 1") {
                        $0.push(widget: SampleWidget())
                    },
                    MainMenuItemWidget(text: "Sample 2") {
                        $0.push(widget: SampleWidget())
                    },
                    MainMenuItemWidget(text: "Sample 3") {
                        $0.push(widget: SampleWidget())
                    },

                    SpacerWidget(),

                    LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
                        .alignment(.center),

                    ]) // VStackWidget
                    .spacing(12)

                ) // ContainerWidget
                .padding(h: 30, v: 20)

            ]) // ZStackWidget
            .navigationBar(title: "Main", hidden: true)
            .backgroundColor(UIColor(white: 0.1, alpha: 1.0))
            .safeArea(false)
        }
}
