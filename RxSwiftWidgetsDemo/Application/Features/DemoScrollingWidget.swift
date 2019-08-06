
import UIKit
import RxSwiftWidgets

struct DemoScrollingWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        let widgets = [Widget].init(repeating: LabelWidget("This is a line."), count: 40)

        return ContainerWidget(
            ScrollWidget(
                VStackWidget(widgets)
                    .spacing(10)
                    .padding(h: 30, v: 20)
                )
            )
            .backgroundColor(.white)
            .navigationBar(title: "Scrolling", hidden: false)
            .safeArea(false)

        }

}
