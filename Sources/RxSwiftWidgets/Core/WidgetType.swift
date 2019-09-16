//
//  WidgetType.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 9/15/19.
//

import UIKit
import RxSwift
import RxCocoa

public protocol WidgetType: Widget {

}

public protocol WidgetViewType: WidgetType {
    func build(with context: WidgetContext) -> UIView
}

public protocol WidgetControllerType: WidgetType {
    func build(with context: WidgetContext) -> UIViewController
}
