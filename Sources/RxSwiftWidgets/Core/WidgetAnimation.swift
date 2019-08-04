//
//  WidgetAnimation.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 8/2/19.
//

import UIKit

public struct WidgetAnimation {

    let duration: TimeInterval

    public init(duration: TimeInterval) {
        self.duration = duration
    }

    public func perform(_ callback: @escaping () -> Void) {
        UIView.animate(withDuration: duration) {
            callback()
        }
    }

    public static func basic(duration: TimeInterval = 0.2) -> WidgetAnimation {
        WidgetAnimation(duration: 0.2)
    }

}
