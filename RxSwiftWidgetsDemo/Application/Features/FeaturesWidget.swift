
import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

struct FeaturesWidget: WidgetView {

    @State private var title: String = "Features"

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
                    .hidden($title.map { $0 == "Features" })
                    .onTap { context in
                        self.title = "Features"
                    },

                SpacerWidget(),
                
                BackButtonWidget(text: "Done"),

                ]) // VStackWidget
                .spacing(15)
                .padding(h: 30, v: 50)

            ]) // ZStackWidget
            .navigationBar(title: "Features", hidden: true)
            .safeArea(false)
        }
}
