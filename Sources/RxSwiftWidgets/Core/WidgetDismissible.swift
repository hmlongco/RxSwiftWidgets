//
//  WidgetDismissible.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 7/28/19.
//

import UIKit

public typealias WidgetDismissibleReturnHandler<ReturnType> = (_ value: ReturnType) -> Void

public protocol WidgetDismissibleType {}

public struct WidgetDismissibleReturn<Value>: WidgetDismissibleType {

    public let handler: WidgetDismissibleReturnHandler<Value>

    public init(_ handler: @escaping WidgetDismissibleReturnHandler<Value>) {
        self.handler = handler
    }

}
