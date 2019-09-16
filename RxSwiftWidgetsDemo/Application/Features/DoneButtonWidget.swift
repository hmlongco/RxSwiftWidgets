
import UIKit
import RxSwift
import RxCocoa
import RxSwiftWidgets

struct BackButtonWidget: WidgetView {

    let text: String

    func widget(_ context: WidgetContext) -> WidgetViewType {
        LabelWidget(text)
            .alignment(.center)
            .alpha(0.0)
            .color(.white)
            .font(.title3)
            .padding(h: 30, v: 10)
            .position(.topRight)
            .onTap{ context in
                context.navigator?.dismiss()
            }
            .with { (view, _) in
                UIView.animate(withDuration: 1.5) {
                    view.alpha = 0.8
                }
            }
    }

}
