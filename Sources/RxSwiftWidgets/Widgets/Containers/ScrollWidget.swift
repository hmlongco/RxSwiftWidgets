//
//  ScrollWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Widgets {
    public enum ScrollAxis {
        case both
        case vertical
        case horizontal
    }
}

public struct ScrollWidget
    : WidgetViewModifying
    , WidgetContaining
    , WidgetPadding
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ScrollWidget()" }

    public var widget: Widget
    public var modifiers = WidgetModifiers()
    public var axis = Widgets.ScrollAxis.vertical

    public init(_ widget: Widget) {
        self.widget = widget
    }

    public func build(with context: WidgetContext) -> UIView {

        let view = WidgetScrollView()
        let context = modifiers.modified(context, for: view)
        let contentView = widget.build(with: context)
        let padding = self.modifiers.padding ?? UIEdgeInsets.zero

        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = axis
        view.padding = padding
        view.addSubview(contentView)

        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding.left).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding.right).isActive = true

        modifiers.apply(to: view, with: context)
        
        return view
    }

    public func automaticallyAdjustForKeyboard() -> Self {
        return modified(WidgetModifierBlock<WidgetScrollView> { scrollView, context in
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak scrollView] (notification) in
                    guard let scrollView = scrollView, let window = scrollView.window else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let info: NSDictionary = notification.userInfo! as NSDictionary
                        // get keyboard frame in window coordinate space
                        let keyboardFrameInWindow = ((info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
                        // get scrollview frame in window coordinate space
                        let scrollViewFrameInWindow = scrollView.convert(scrollView.frame, to: window)
                        // compute intersection
                        let intersection = scrollViewFrameInWindow.intersection(keyboardFrameInWindow)
                        // if intersects, inset scrollview by that amount
                        if intersection.height > 0 {
                            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: intersection.height, right: 0)
                            scrollView.contentInset = contentInsets
                            scrollView.scrollIndicatorInsets = contentInsets
                        }
                    }
                })
                .disposed(by: context.disposeBag)

            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak scrollView] _ in
                    if let scrollView = scrollView, scrollView.contentInset.bottom > 0 {
                        scrollView.contentInset = UIEdgeInsets.zero
                        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                    }
                })
                .disposed(by: context.disposeBag)
        })
    }

    public func axis(_ axis: Widgets.ScrollAxis) -> Self {
        return modified { $0.axis = axis }
    }

    /// Pass an UIScrollViewDelegate object and it will be assigned as the delegate for the generated UIScrollView.
    public func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return modified(WidgetModifierBlock<WidgetScrollView> { view, _ in
            view.delegateReference = delegate
            view.delegate = delegate
        })
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIScrollView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}

internal class WidgetScrollView: UIScrollView, WidgetViewCustomConstraints {

    var axis: Widgets.ScrollAxis = .both
    var delegateReference: UIScrollViewDelegate?
    var padding: UIEdgeInsets!

    func addCustomConstraints() {
        guard let superview = superview, let subview = subviews.first else { return }
        switch axis {
        case .vertical:
            let padding = self.padding.left + self.padding.right
            subview.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -padding).isActive = true
        case .horizontal:
            let padding = self.padding.top + self.padding.bottom
            subview.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -padding).isActive = true
        case .both:
            break
        }
    }

}
