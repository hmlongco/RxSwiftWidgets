
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

                ContainerWidget(
                    ImageWidget(named: "Solutions-Center-logo")
                        .height(90)
                        .contentMode(.scaleAspectFit)
                        .position(.centerHorizontally)
                    )
                    .padding(h: 0, v: 30),

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

                ContainerWidget(
                    HStackWidget([
                        ButtonWidget("Present")
                            .color(.orange)
                            .font(.footnote)
                            .onTap { context in
                                context.present(widget: SampleDestinationWidget()) { (string: String) in
                                    print(string)
                                }
                            },
                        ButtonWidget("Push")
                            .color(.orange)
                            .font(.footnote)
                            .onTap { context in
                                context.push(widget: SampleDestinationWidget()) { (string: String) in
                                    print(string)
                                }
                            },
                        ])
                        .position(.centerHorizontally)
                    ),

                SpacerWidget(),

                HStackWidget([
                ZStackWidget([
                    LabelWidget.title3("CL")
                        .position(.centerLeft),
                    LabelWidget.title3("CR")
                        .position(.centerRight),
                    LabelWidget.title3("CT")
                        .position(.centerTop),
                    LabelWidget.title3("CB")
                        .position(.centerBottom),
                    ])
                    .padding(10)
                    .height(100),

                ZStackWidget([
                    LabelWidget.title3("TL")
                        .position(.topLeft),
                    LabelWidget.title3("TR")
                        .position(.topRight),
                    LabelWidget.title3("BL")
                        .position(.bottomLeft),
                    LabelWidget.title3("BR")
                        .position(.bottomRight),
                    LabelWidget.title3("CT")
                        .position(.center),
                    ])
                    .padding(10)
                    .height(100),
                ])
                .distribution(.fillEqually),

                LabelWidget.footnote("A footnote")
                    .alignment(.center)
                    .onTap { _ in
                        self.viewModel.labelPublisher.onNext("Changed again!")
                    },

                ]) // ColumnWidget
                .padding(20)

            ) // ContainerWidget
            .context { $0.put(UIFont.preferredFont(forTextStyle: .title1)) }
            .onWillAppear { _ in self.viewModel.load() }
            .navigationBar(title: "Sample", hidden: false)
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
    static func footnote(_ text: String) -> LabelWidget {
        LabelWidget(text)
            .color(.gray)
            .font(.preferredFont(forTextStyle: .footnote))
    }
}

struct SampleDestinationWidget: WidgetView {
     func widget(_ context: WidgetContext) -> Widget {
        ContainerWidget(
            VStackWidget([
                LabelWidget("Testing")
                    .color(.white)
                    .font(context.get()) // note context extraction of font
                    .position(.center),

                ButtonWidget("Done")
                    .color(.orange)
                    .font(.footnote)
                    .onTap { $0.dismiss(returning: "Some Value") },

                ButtonWidget("Cancel")
                    .color(.orange)
                    .font(.footnote)
                    .onTap { $0.dismiss() }
                ])
                .alignment(.center)
                .position(.center)
            )
            .backgroundColor(UIColor(white: 0.1, alpha: 1.0))
            .navigationBar(title: "Details", preferLargeTitles: false, hidden: false)
        }
 }
