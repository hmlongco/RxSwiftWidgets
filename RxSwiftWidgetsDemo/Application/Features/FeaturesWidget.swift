
import UIKit
import RxSwiftWidgets

struct FeaturesWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStackWidget([

                LabelWidget("Features")
                    .font(.title1)
                    .color(.white)
                    .alignment(.center)
                    .padding(20),

                MainMenuItemWidget(text: "Dismissible") { context in
                    context.navigator?.push(widget: DemoDismissibleWidget(), onDismiss: { (value: String) in
                        print(value)
                    })
                },
                MainMenuItemWidget(text: "Positioning") { context in
                    context.navigator?.push(widget: DemoPositioningWidget())
                },

                SpacerWidget(),
                
                DoneButtonWidget(),

                ]) // VStackWidget
                .spacing(15)
                .padding(h: 30, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Features", hidden: true)
            .safeArea(false)
        }
}

struct DoneButtonWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {
        LabelWidget("Done")
            .alignment(.center)
            .alpha(0.8)
            .color(.white)
            .font(.title3)
            .onTap{ context in
                context.navigator?.dismiss()
            }
    }

}
