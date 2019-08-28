
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

            ScrollWidget(

                VStackWidget([

                    LabelWidget($title)
                        .font(.title1)
                        .color(.white)
                        .alignment(.center)
                        .padding(20),

                    MainMenuItemWidget(text: "Property Binding", onTap: { (context) in
                         context.navigator?.push(widget: DemoBindingWidget(title: self.$title))
                    }),

                    MainMenuItemWidget(text: "Dismissible", onTap: { context in
                        context.navigator?.push(widget: DemoDismissibleWidget(), onDismiss: { (value: String) in
                            print(value)
                        })
                    }),

                    MainMenuItemWidget(text: "Positioning", onTap: { context in
                        context.navigator?.push(widget: DemoPositioningWidget())
                    }),

                    MainMenuItemWidget(text: "Scrolling", onTap: { context in
                        context.navigator?.push(widget: DemoScrollingWidget())
                    }),

                    MainMenuItemWidget(text: "Static TableView", onTap: { context in
                        context.navigator?.push(widget: DemoStaticTableViewWidget())
                    }),

                    ButtonWidget("Reset Title")
                        .color(.orange)
                        .hidden($title.map { $0 == "Features" })
                        .onTap { context in
                            UIView.animate(withDuration: 0.2) {
                                self.title = "Features"
                            }
                        },

                    SpacerWidget(),

                    BackButtonWidget(text: "Done"),

                    ]) // VStackWidget
                    .spacing(15)
                    .padding(h: 30, v: 50)
                    .onEvent($title, handle: { (value, _) in
                        print(value)
                    })
                )
                .safeArea(false)

            ]) // ZStackWidget
            .navigationBar(title: "Features", hidden: true)
            .safeArea(false)
        
        }
}
