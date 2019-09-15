
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
                         context.navigator?.push(DemoBindingWidget(title: self.$title))
                    }),

                    MainMenuItemWidget(text: "Dismissible", onTap: { context in
                        context.navigator?.present(DemoDismissibleWidget(), onDismiss: { (value: String) in
                            self.showAlert(value, with: context)
                        })
                    }),

                    MainMenuItemWidget(text: "Positioning", onTap: { context in
                        context.navigator?.push(DemoPositioningWidget())
                    }),

                    MainMenuItemWidget(text: "Scrolling", onTap: { context in
                        context.navigator?.push(DemoScrollingWidget())
                    }),

                    MainMenuItemWidget(text: "Static TableView", onTap: { context in
                        context.navigator?.push(DemoStaticTableViewWidget())
                    }),

                    ButtonWidget("Reset Title")
                        .color(.orange)
                        .hidden($title.map { $0 == "Features" })
                        .onTap { context in
                            UIView.animate(withDuration: 0.2) {
                                self.title = "Features"
                            }
                        },

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

    func showAlert(_ value: String, with context: WidgetContext) {
        OperationQueue.main.addOperation {
            let alert = AlertWidget(title: "Returned", message: value)
                .addAction(title: "Okay") { _ in
                    self.showAlert("Onward!", with: context)
                }
                .addAction(title: "Cancel", style: .cancel)
            context.navigator?.present(alert)
        }
    }
    
}
