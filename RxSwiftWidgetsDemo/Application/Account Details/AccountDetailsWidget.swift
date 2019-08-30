
import UIKit
import RxSwift
import RxSwiftWidgets

struct AccountDetailsWidget: WidgetView {

    let viewModel = AccountDetailsViewModel()

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget([

            ImageWidget(named: "vector2")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            ScrollWidget(

                VStackWidget([

                    ContainerWidget(
                        SpinnerWidget().color(.gray)
                    )
                    .padding(15)
                    .hidden(viewModel.loading.map { !$0 }),

                    VStackWidget([

                        LabelWidget(viewModel.title)
                            .alignment(.center)
                            .color(.red)
                            .font(.title1),

                        NameValueSectionWidget(values: viewModel.accountDetails),

                        NameValueSectionWidget(values: viewModel.paymentDetails),

                        LabelWidget(viewModel.footnotes)
                            .color(.gray)
                            .font(.footnote)
                            .numberOfLines(0)
                            .padding(h: 15, v: 0),
                        ])
                        .spacing(20)
                        .hidden(viewModel.loading),

                    SpacerWidget(),

                    ]) // VStackWidget
                    .spacing(15)

                ) // ScrollWidget
                .padding(h: 30, v: 20)
                .safeArea(false)

            ]) // ZStackWidget
            .navigationBar(title: "Account Details", hidden: false)
            .safeArea(false)
            .onViewDidAppear { _ in
                self.viewModel.load()
            }
    }

}


fileprivate struct NameValueSectionWidget: WidgetView {

    let values: Observable<[AccountInformation.AccountDetails]>

    func widget(_ context: WidgetContext) -> Widget {
        ContainerWidget(
            VStackWidget(values) {
                HStackWidget([
                    LabelWidget($0.name)
                        .color(.gray),
                    SpacerWidget(),
                    LabelWidget($0.value)
                        .color(.darkText),
                    ])
            })
            .padding(20)
            .cornerRadius(20)
            .backgroundColor(UIColor(white: 0.9, alpha: 0.6))
    }

}
