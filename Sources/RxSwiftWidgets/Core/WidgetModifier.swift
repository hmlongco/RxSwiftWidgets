//
//  WidgetModifying.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// A type-erased widget view modifier
public protocol AnyWidgetModifier {
    func apply(to view: UIView, with context: WidgetContext)
}

/// Standard widget modifier that updates the view using keypath and values
public struct WidgetModifier<View:UIView, Value>: AnyWidgetModifier {

    public let keyPath: WritableKeyPath<View, Value>
    public let value: Value

    public init(keyPath: WritableKeyPath<View, Value>, value: Value) {
        self.keyPath = keyPath
        self.value = value
    }

    public func apply(to view: UIView, with context: WidgetContext) {
        if var view = view as? View {
            view[keyPath: keyPath] = value
        }
    }
}


public typealias WidgetModifierBlockType<View:UIView> = (View, WidgetContext) -> Void

/// Standard widget modifier that updates the view using a closure block
public struct WidgetModifierBlock<View:UIView>: AnyWidgetModifier {

    public let modifier: WidgetModifierBlockType<View>

    public init(_ modifier: @escaping WidgetModifierBlockType<View>) {
        self.modifier = modifier
    }

    public func apply(to view: UIView, with context: WidgetContext) {
        if let view = view as? View {
            modifier(view, context)
        }
    }

}
