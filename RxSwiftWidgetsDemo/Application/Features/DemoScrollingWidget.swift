
import UIKit
import RxSwiftWidgets

struct DemoScrollingWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {

        let widgets = [Widget].init(repeating: Text("This is a line."), count: 40)

        return Container(
            ScrollWidget(
                VStack(widgets)
                    .spacing(10)
                    .padding(h: 30, v: 20)
                )
            )
            .backgroundColor(.white)
            .navigationBar(title: "Scrolling", hidden: false)
            .safeArea(false)

        }

}
