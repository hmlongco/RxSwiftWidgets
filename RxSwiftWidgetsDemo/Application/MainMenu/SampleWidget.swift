
import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

public class SampleWidgetViewModel {

    let titleText = "Michael Long"

    var labelText1 = "Test"
    var labelText2 = "Michael Long"

    let labelPublisher = PublishSubject<String>()
    let imageNamePublisher = PublishSubject<String>()
    let errorPublisher = BehaviorRelay<String?>(value: nil)

    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.imageNamePublisher.onNext("User-ML")
        }
    }
}

struct SampleWidget: WidgetView {

    public let viewModel = SampleWidgetViewModel()

    func widget(_ context: WidgetContext) -> Widget {

        ContainerWidget(

            VStackWidget([

                 HStackWidget([
                    ImageWidget()
                        .image(viewModel.imageNamePublisher)
                        .backgroundColor(.gray)
                        .cornerRadius(30)
                        .clipsToBounds(true)
                        .height(60)
                        .width(60),

                    TitleWidgetView(title: viewModel.labelText2),
                    ])
                    .padding(10),

                LabelWidget()
                    .text(viewModel.labelText1)
                    .font(.preferredFont(forTextStyle: .title2))
                    .backgroundColor(.gray)
                    .padding(4)
                    .with { (label, _) in
                        label.adjustsFontSizeToFitWidth = true
                    },

                LabelWidget()
                    .text(viewModel.labelText2)
                    .text(viewModel.labelPublisher)
                    .text(viewModel.labelPublisher.map { $0 })
                    .font(.preferredFont(forTextStyle: .title2))
                    .backgroundColor(.gray)
                    .padding(4),

                LabelWidget()
                    .text(viewModel.errorPublisher)
                    .font(.preferredFont(forTextStyle: .callout))
                    .color(.white)
                    .backgroundColor(.red)
                    .numberOfLines(0)
                    .padding(5)
                    .hidden(viewModel.errorPublisher.map { $0 == nil }),

                HStackWidget([
                    LabelWidget.title3("•"),
                    LabelWidget.title3("Remember Me"),
                    SpacerWidget(),
                    UIViewWidget(UISwitch())
                        .with { (view, _) in
                            view.isOn = true
                        }
                ]),

                ButtonWidget("Toggle Error")
                    .color(.orange)
                    .font(.footnote)
                    .onTap { _ in
                        if self.viewModel.errorPublisher.value == nil {
                            self.viewModel.errorPublisher.accept("This is an error!")
                        } else {
                            self.viewModel.errorPublisher.accept(nil)
                        }
                    },

                SpacerWidget(),

                BackButtonWidget(text: "Done"),

                ]) // ColumnWidget
                .padding(20)

            ) // ContainerWidget
            .context { $0.put(UIFont.preferredFont(forTextStyle: .title1)) }
            .onScreenWillAppear { _ in self.viewModel.load() }
            .navigationBar(title: "Sample", hidden: true)
            .backgroundColor(UIColor(white: 0.1, alpha: 1.0))
            .safeArea(false)
        }
}

struct TitleWidgetView: WidgetView {
    var title: String
    func widget(_ context: WidgetContext) -> Widget {
        LabelWidget("Initial Value")
            .text(title)
            .color(.white)
            .font(context.get()) // note context extraction of font
            .contentHuggingPriority(.defaultHigh, for: .horizontal)
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
