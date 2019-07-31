
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

            VStackWidget([

                LabelWidget("Loading...")
                    .alignment(.center)
                    .color(.gray)
                    .hidden(viewModel.loading.map { !$0 }),

                VStackWidget([
                    LabelWidget()
                        .text(viewModel.title)
                        .alignment(.center)
                        .color(.darkText)
                        .font(.title2),

                    ContainerWidget(
                        VStackWidget([])
                            .contents(viewModel.accountDetails.map { details in
                                details.map { self.accountDetailsRow($0) }
                            })
                        )
                        .padding(20)
                        .cornerRadius(20)
                        .backgroundColor(UIColor(white: 0.9, alpha: 0.6)),

                    ContainerWidget(
                        VStackWidget([])
                            .contents(viewModel.paymentDetails.map { details in
                                details.map { self.accountDetailsRow($0) }
                            })
                        )
                        .padding(20)
                        .cornerRadius(20)
                        .backgroundColor(UIColor(white: 0.9, alpha: 0.6)),

                        LabelWidget()
                            .text(viewModel.footnotes)
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
                .padding(h: 30, v: 20)

            ]) // ZStackWidget
            .navigationBar(title: "Account Details", hidden: false)
            .safeArea(false)
            .onDidAppear { _ in
                self.viewModel.load()
            }
        }

    func accountDetailsRow(_ detail: AccountInformation.AccountDetails) -> Widget {
        return HStackWidget([
            LabelWidget(detail.name)
                .color(.gray),
            SpacerWidget(),
            LabelWidget(detail.value)
                .color(.darkText),
            ])
    }

}
