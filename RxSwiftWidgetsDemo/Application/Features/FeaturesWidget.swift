
import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

struct FeaturesWidget: WidgetView {

    @State var title: String = "Features"

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStackWidget([

                LabelWidget()
                    .text($title)
                    .font(.title1)
                    .color(.white)
                    .alignment(.center)
                    .padding(20),

                MainMenuItemWidget(text: "Property Binding") { context in
                    context.navigator?.push(widget: DemoBindingWidget(title: self.$title))
                },

                MainMenuItemWidget(text: "Dismissible") { context in
                    context.navigator?.push(widget: DemoDismissibleWidget(), onDismiss: { (value: String) in
                        print(value)
                    })
                },
                
                MainMenuItemWidget(text: "Positioning") { context in
                    context.navigator?.push(widget: DemoPositioningWidget())
                },

                ButtonWidget("Reset Title")
                    .color(.orange)
                    .hidden($title.asObservable().map { $0 == "Features" })
                    .onTap { context in
                        self.title = "Features"
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
