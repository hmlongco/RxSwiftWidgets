//
//  WidgetBuilder.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 3/11/20.
//

import Foundation

@_functionBuilder
public struct WidgetBuilder {
    public static func buildBlock(_ widgets: Widget...) -> [Widget] {
        widgets
    }
}
