
import UIKit
import RxSwiftWidgets

struct LoginFormWidget: WidgetView {

    func widget(_ context: WidgetContext) -> Widget {
        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            ScrollWidget(
                VStackWidget([
                    logoWidget,
                    usernameFieldWidget,
                    passwordFieldWidget,
                    VStackWidget([
                        loginButtonWidget,
                        footnoteWidget,
                        ])
                        .padding(h: 0, v: 10)
                        .spacing(5)
                    ]) // VStackWidget
                    .spacing(20)
                    .padding(h: 0, v: 50)
                ) // ScrollWidget
                .automaticallyAdjustForKeyboard()
                .safeArea(false),

            ]) // ZStackWidget
            .navigationBar(title: "Login", hidden: true)
            .safeArea(false)
        }

    var logoWidget: Widget {
        ContainerWidget(
        HStackWidget([
            ImageWidget(named: "RxSwiftWidgets-Logo-DK")
                .height(100)
                .width(100)
                .contentMode(.scaleAspectFit),
            LabelWidget("RxSwiftWidgets")
                .font(.title2)
                .color(.white)
            ])
            .position(.centerHorizontally)
        )
    }

    var usernameFieldWidget: Widget {
        ContainerWidget(
            VStackWidget([
                LabelWidget.footnote("Username"),
                TextFieldWidget("Michael Long")
                    .font(.title2)
                    .color(.black)
                    .with { textField, _ in
                        textField.isSecureTextEntry = false
                        textField.keyboardAppearance = .dark
                    }
                ])
                .spacing(0)
            )
            .backgroundColor(UIColor(white: 1.0, alpha: 0.8))
            .padding(h: 30, v: 10)
    }

    var passwordFieldWidget: Widget {
        ContainerWidget(
            VStackWidget([
                LabelWidget.footnote("Password"),
                TextFieldWidget("")
                    .font(.title2)
                    .color(.black)
                    .with { textField, _ in
                        textField.isSecureTextEntry = true
                        textField.keyboardAppearance = .dark
                    }
                ])
                .spacing(0)
            )
            .backgroundColor(UIColor(white: 1.0, alpha: 0.8))
            .padding(h: 30, v: 10)
    }

    var loginButtonWidget: Widget {
        ButtonWidget("Login")
            .backgroundColor(UIColor(red: 0.8, green: 0.0, blue: 0.4, alpha: 0.7))
            .font(.title2)
            .color(.white)
            .padding(h: 30, v: 15)
            .onTap(handler: { (context) in
                context.navigator?.dismiss()
            })
    }

    var footnoteWidget: Widget {
        LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
            .alignment(.center)
            .padding(h: 20, v: 20)
    }

}
