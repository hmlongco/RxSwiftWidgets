
import UIKit
import RxSwift
import RxCocoa

public struct DisclosableWidget: Widget, WidgetContaining, WidgetPadding, WidgetViewModifying {

    public var widget: Widget

    public init(_ widget: Widget) {
        self.widget = widget
    }

    public var modifiers = WidgetModifiers()

    private var color = UIColor.init(white: 0.85, alpha: 1.0)

    public func build(with context: WidgetContext) -> UIView {

        let enclosure = UIView()
        let context = context.set(view: enclosure)
        let childView = widget.build(with: context)

        enclosure.backgroundColor = .clear
        enclosure.addSubview(childView)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\u{203A}"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = color
        label.backgroundColor = .clear
        enclosure.addSubview(label)

        let padding = self.modifiers.padding ?? UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        childView.topAnchor.constraint(equalTo: enclosure.topAnchor, constant: padding.top).isActive = true
        childView.bottomAnchor.constraint(equalTo: enclosure.bottomAnchor, constant: -padding.bottom).isActive = true
        childView.leadingAnchor.constraint(equalTo: enclosure.leadingAnchor, constant: padding.left).isActive = true
        label.trailingAnchor.constraint(equalTo: enclosure.trailingAnchor, constant: -padding.right).isActive = true

        label.leadingAnchor.constraint(equalTo: childView.trailingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: enclosure.centerYAnchor).isActive = true

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)

        modifiers.apply(to: enclosure, with: context)

        return enclosure
    }

    public func color(_ color: UIColor) -> Self {
        return modified { $0.color = color }
    }

}
