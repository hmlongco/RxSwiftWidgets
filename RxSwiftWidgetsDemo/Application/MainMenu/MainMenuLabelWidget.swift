
import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

struct MainMenuItemWidget: WidgetView, WidgetViewModifying {

    let text: String
    let onTap: (WidgetContext) -> Void

    var modifiers: WidgetModifiers? = []

    func widget(_ context: WidgetContext) -> Widget {
        LabelWidget(text)
            .backgroundColor(.init(white: 1.0, alpha: 0.3))
            .clipsToBounds(true)
            .cornerRadius(10)
            .color(.white)
            .font(.preferredFont(forTextStyle: .title3))
            .padding(h: 20, v: 10)
            .onTap(handler: onTap)
    }

}
