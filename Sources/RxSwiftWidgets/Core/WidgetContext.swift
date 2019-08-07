//
//  WidgetContext.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//
//    func test1() {
//        let context = self.put(Navigator())
//        if let navigator: Navigator = context.find() {
//            print(navigator.depth())
//        }
//    }
//
//    func test2() {
//        let context = self
//            .set(UIFont.preferredFont(forTextStyle: .title2), for: WidgetContext.Keys.titleFont)
//            .set(UIFont.preferredFont(forTextStyle: .callout), for: WidgetContext.Keys.bodyFont)
//
//        if let font: UIFont = context.find(WidgetContext.Keys.bodyFont) {
//            print(font.familyName)
//        }
//    }

import UIKit
import RxSwift
import RxCocoa

public struct WidgetContext {

    public struct Keys {}

    public weak var parentView: UIView?
    public weak var view: UIView?

    public var attributes: [String:Any?] = [:]
    public var disposeBag: DisposeBag

    public init() {
        self.disposeBag = DisposeBag()
    }

    public func set(view: UIView) -> WidgetContext {
        var context = self
        context.parentView = context.view
        context.view = view
        return context
    }

    public func get<T>(_ key: String) -> T {
        // siwftlint:disable force_unwrapping
        (attributes[key] as? T)!
        // siwftlint:enable force_unwrapping
    }

    public func get<T>(_ type: T.Type = T.self) -> T {
        // siwftlint:disable force_unwrapping
        (attributes[String(describing: type)] as? T)!
        // siwftlint:enable force_unwrapping
    }

    public func find<T>(_ key: String) -> T? {
        attributes[key] as? T
    }

    public func find<T>(_ type: T.Type = T.self) -> T? {
        attributes[String(describing: type)] as? T
    }

    public func put<T>(_ object: T) -> WidgetContext {
        var context = self
        context.attributes[String(describing: T.self)] = object
        return context
    }

    public func set<T>(_ value: T?, for key: String) -> WidgetContext {
        var context = self
        context.attributes[key] = value
        return context
    }
    
}

public extension WidgetContext.Keys {
    static var accentColor = "accentColor"
    static var titleFont = "titleFont"
    static var bodyFont = "bodyFont"
}

public typealias WidgetContextModifier = (WidgetContext) -> WidgetContext

public protocol WidgetContextModifiying {
    var contextModifier: WidgetContextModifier? { get set }
    func context(_ modifier: @escaping WidgetContextModifier) -> Self
}

extension WidgetContextModifiying {

    public func context(_ modifier: @escaping WidgetContextModifier) -> Self {
        var widget = self
        widget.contextModifier = modifier
        return widget
    }

}
