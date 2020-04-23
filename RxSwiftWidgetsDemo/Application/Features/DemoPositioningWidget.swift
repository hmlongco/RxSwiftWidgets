
import UIKit
import RxSwiftWidgets

struct DemoPositioningWidget: WidgetView {

    let desc = """
        Uses a ZStack to demonstrate multiple ways of positioning widgets within a container.
        """

    func widget(_ context: WidgetContext) -> Widget {

        let widget = ZStackWidget {

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false)

            VStackWidget {

                LabelWidget("Positioning Sample")
                    .font(.title1)
                    .color(.white)
                    .alignment(.center)

                LabelWidget(desc)
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.white)
                    .numberOfLines(0)
                    .padding(h: 0, v: 15)

                borderedStack([
                    LabelWidget.title3("Center Left")
                        .position(.centerLeft),
                    LabelWidget.title3("Center Right")
                        .position(.centerRight),
                    LabelWidget.title3("Center Top")
                        .position(.centerTop),
                    LabelWidget.title3("Center Bottom")
                        .position(.centerBottom),
                    ])

                borderedStack([
                    LabelWidget.title3("Top Left")
                        .position(.topLeft),
                    LabelWidget.title3("Top Right")
                        .position(.topRight),
                    LabelWidget.title3("Bottom Left")
                        .position(.bottomLeft),
                    LabelWidget.title3("Bottom Right")
                        .position(.bottomRight),
                    LabelWidget.title3("Center")
                        .position(.center),
                    ])

                SpacerWidget()

                BackButtonWidget(text: "Done")

            } // VStackWidget
            .spacing(15)
            .padding(h: 40, v: 50)

        } // ZStackWidget
        .navigationBar(title: "Dismissible Demo", hidden: true)
        .safeArea(false)

        widget.walk { print($0) }

        return widget
    }

    func borderedStack(_ widgets: [Widget]) -> Widget {
        ZStackWidget(widgets)
            .border(color: .lightGray)
            .padding(10)
            .height(120)
    }

}

extension LabelWidget {
    static func title3(_ text: String) -> LabelWidget {
        LabelWidget(text)
            .color(.white)
            .font(.preferredFont(forTextStyle: .title3))
            .contentHuggingPriority(.defaultHigh, for: .horizontal)
            .padding(h: 0, v: 4)
    }
}
