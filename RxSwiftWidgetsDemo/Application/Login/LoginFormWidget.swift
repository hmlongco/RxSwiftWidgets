
import UIKit
import RxSwiftWidgets

struct LoginFormWidget: WidgetView {

    @State var username: String = "Michael Long"
    @State var password: String = ""
    @State var error: String = ""

    func widget(_ context: WidgetContext) -> Widget {
        ZStackWidget([

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false),

            ScrollWidget(
                VStackWidget([
                    logoSection,
                    errorSection,
                    usernameSection,
                    passwordSection,
                    VStackWidget([
                        loginButtonSection,
                        footnoteSection,
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

    var logoSection: Widget {
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
            .padding(10)
            .position(.centerHorizontally)
        )
    }

    var errorSection: Widget {
        LabelWidget($error)
            .color(.white)
            .numberOfLines(0)
            .padding(h: 30, v: 0)
            .hidden($error.map { $0.isEmpty })
    }

    var usernameSection: Widget {
        ContainerWidget(
            VStackWidget([
                LabelWidget.footnote("Username"),
                TextFieldWidget($username)
                    .placeholder("Username / Email Address")
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
            .padding(h: 30, v: 8)
    }

    var passwordSection: Widget {
        ContainerWidget(
            VStackWidget([
                LabelWidget.footnote("Password"),
                TextFieldWidget($password)
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
            .padding(h: 30, v: 8)
    }

    var loginButtonSection: Widget {
        ButtonWidget("Login")
            .backgroundColor(UIColor(red: 0.8, green: 0.0, blue: 0.4, alpha: 0.8))
            .font(.title2)
            .color(.white)
            .padding(h: 30, v: 14)
            .onTap(handler: { (context) in
                guard !self.username.isEmpty && !self.password.isEmpty else {
                    UIView.animate(withDuration: 0.2) {
                        self.error = "Username and password is required."
                    }
                    return
                }
                context.navigator?.dismiss()
            })
    }

    var footnoteSection: Widget {
        LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
            .alignment(.center)
            .padding(h: 20, v: 20)
    }

}
