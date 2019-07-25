//
//  ImageWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct ImageWidget: WidgetViewModifying {

    public var modifiers: WidgetModifiers?

    public var image: UIImage?
    public var name: String?

    public init(named name: String? = nil) {
        self.name = name
    }

    public init(_ image: UIImage) {
        self.image = image
    }

    public func build(with context: WidgetContext) -> UIView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if let name = name {
            view.image = UIImage(named: name)
        } else if let image = image {
            view.image = image
        }

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func image(_ image: UIImage?) -> Self {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            view.image = image
        })
    }

    public func image(named name: String) -> Self {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            view.image = UIImage(named: name)
        })
    }

    public func image<Observable:WidgetObservable>(_ observable: Observable) -> Self where Observable.Element == UIImage? {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().bind(to: view.rx.image).disposed(by: context.disposeBag)
        })
    }

    public func image<Observable:WidgetObservable>(_ observable: Observable) -> Self where Observable.Element == String {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().map { UIImage(named: $0) }.bind(to: view.rx.image).disposed(by: context.disposeBag)
        })
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIImageView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
