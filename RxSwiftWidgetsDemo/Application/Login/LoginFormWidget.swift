
import UIKit
import RxSwift
import RxSwiftWidgets

struct LoginFormWidget: WidgetView {

    @State var username: String = "Michael Long"
    @State var password: String = ""
    @State var authenticated: Bool = false
    @State var error: String = ""

    func widget(_ context: WidgetContext) -> Widget {

        ZStackWidget {

            ImageWidget(named: "vector1")
                .contentMode(.scaleAspectFill)
                .safeArea(false)

            ScrollWidget {
                VStackWidget {
                    logoSection
                    ErrorMessageWidget(message: $error)
                    SpacerWidget(v: 20)
                    usernameSection
                    SpacerWidget(v: 10)
                    passwordSection
                    SpacerWidget(v: 20)
                    loginButtonSection
                    footnoteSection
                }
                .spacing(5)
                .padding(h: 0, v: 50)
            }
            .automaticallyAdjustForKeyboard()
            .safeArea(false)

            BackButtonWidget(text: "X")

        } // ZStackWidget
        .navigationBar(title: "Login", hidden: true)
        .safeArea(false)
        .onEvent($authenticated.filter { $0 }) { (_, context) in
            context.navigator?.dismiss()
        }

    }

    var logoSection: Widget {
        ContainerWidget {
            HStackWidget {
                ImageWidget(named: "RxSwiftWidgets-Logo-DK")
                    .height(100)
                    .width(100)
                    .contentMode(.scaleAspectFit)
                LabelWidget("RxSwiftWidgets")
                    .font(.title2)
                    .color(.white)
            }
            .padding(10)
            .position(.centerHorizontally)
        }
    }

    var usernameSection: Widget {
        ContainerWidget(
            VStackWidget {
                LabelWidget.footnote("Username")
                TextFieldWidget($username)
                    .placeholder("Username / Email Address")
                    .font(.title2)
                    .color(.black)
                    .with { textField, _ in
                        textField.isSecureTextEntry = false
                        textField.keyboardAppearance = .dark
                    }
                }
                .spacing(0)
            )
            .backgroundColor(UIColor(white: 1.0, alpha: 0.8))
            .padding(h: 30, v: 8)
    }

    var passwordSection: Widget {
        ContainerWidget {
            VStackWidget {
                LabelWidget.footnote("Password")
                TextFieldWidget($password)
                    .font(.title2)
                    .color(.black)
                    .with { textField, _ in
                        textField.isSecureTextEntry = true
                        textField.keyboardAppearance = .dark
                    }
                    .onEditingDidEndOnExit { (_, _) in
                        self.login()
                    }
                }
                .spacing(0)
            }
            .backgroundColor(UIColor(white: 1.0, alpha: 0.8))
            .padding(h: 30, v: 8)
    }

    var loginButtonSection: Widget {
        ButtonWidget("Login")
            .backgroundColor(UIColor(red: 0.8, green: 0.0, blue: 0.4, alpha: 0.8))
            .font(.title2)
            .color(.white)
            .padding(h: 30, v: 14)
            .onTap(handler: { _ in
                self.login()
            })
    }

    var footnoteSection: Widget {
        LabelWidget.footnote("RxSwiftWidgets Demo Version 0.7\nCreated by Michael Long")
            .alignment(.center)
            .padding(h: 20, v: 20)
    }

    func login() {
        guard !self.username.isEmpty && !self.password.isEmpty else {
            error = "Username and password is required."
            return
        }
        error = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.password = ""
            self.authenticated = true
        }
    }

}
