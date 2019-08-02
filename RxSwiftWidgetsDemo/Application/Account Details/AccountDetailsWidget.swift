
import UIKit
import RxSwift
import RxSwiftWidgets

struct AccountDetailsWidget: WidgetView {

    let viewModel = AccountDetailsViewModel()

    func widget(_ context: WidgetContext) -> Widget {

        ZStack([

            Image(named: "vector2")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            VStack([

                Container(
                    Spinner().color(.gray)
                )
                .padding(15)
                .hidden(viewModel.loading.map { !$0 }),

                VStack([
                    Text()
                        .text(viewModel.title)
                        .alignment(.center)
                        .color(.red)
                        .font(.title1),

                    Container(
                        VStack()
                            .bind(viewModel.accountDetails) {
                                self.accountDetailsRow($0)
                            }
                        )
                        .padding(20)
                        .cornerRadius(20)
                        .backgroundColor(UIColor(white: 0.9, alpha: 0.6)),

                    Container(
                        VStack()
                             .bind(viewModel.paymentDetails) {
                                self.accountDetailsRow($0)
                            }
                        )
                        .padding(20)
                        .cornerRadius(20)
                        .backgroundColor(UIColor(white: 0.9, alpha: 0.6)),

                        Text()
                            .text(viewModel.footnotes)
                            .color(.gray)
                            .font(.footnote)
                            .numberOfLines(0)
                            .padding(h: 15, v: 0),
                    ])
                    .spacing(20)
                    .hidden(viewModel.loading),


                Spacer(),

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
        return HStack([
            Text(detail.name)
                .font(.body)
                .color(.gray),
            Spacer(),
            Text(detail.value)
                .color(.darkText),
            ])
    }

}
