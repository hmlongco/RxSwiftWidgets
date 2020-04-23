
import UIKit
import RxSwiftWidgets

struct DemoScrollingWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        let widgets = [Widget].init(repeating: LabelWidget("This is a line.").color(.white), count: 40)

        return ContainerWidget {
            ScrollWidget {
                VStackWidget(widgets)
                    .spacing(10)
                    .padding(h: 30, v: 20)
            }
        }
        .backgroundColor(.black)
        .navigationBar(title: "Scrolling", hidden: false)
        .safeArea(false)

    }

}
