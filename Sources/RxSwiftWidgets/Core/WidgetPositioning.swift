//
//  WidgetPositioning.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

extension Widgets {
    public enum Position {

        case fill

        case left
        case top
        case bottom
        case right

        case topLeft
        case topRight
        case bottomLeft
        case bottomRight

        case center
        case centerLeft
        case centerTop
        case centerBottom
        case centerRight
        case centerHorizontally
        case centerVertically

    }
}


extension WidgetModifying {

    public func position(_ position: Widgets.Position) -> Self {
//        return modified(WidgetModifierBlock<UIView> { view, _ in
//            view.widget.position = position
//        })
        return modified(WidgetModifier(keyPath: \UIView.widget.position, value: position))
    }

}

extension Widgets.Position {
    
    func apply(to view: UIView, padding: UIEdgeInsets, safeArea: Bool) {
        guard let superview = view.superview else { return }

        var constraints = [NSLayoutConstraint]()

        constraints.reserveCapacity(6)

        // left
        switch self {
        case .fill, .left, .top, .bottom, .topLeft, .bottomLeft, .centerLeft, .centerVertically:
            constraints.append(anchorLeftEdge(of: view, in: superview, padding: padding.left, safeArea: safeArea))
        default:
            constraints.append(limitLeftEdge(of: view, in: superview, padding: padding.left, safeArea: safeArea))
        }

        // top
        switch self {
        case .fill, .top, .left, .right, .topLeft, .topRight, .centerTop, .centerHorizontally:
            constraints.append(anchorTopEdge(of: view, in: superview, padding: padding.top, safeArea: safeArea))
        default:
            constraints.append(limitTopEdge(of: view, in: superview, padding: padding.top, safeArea: safeArea))
        }

        // bottom
        switch self {
        case .fill, .bottom, .left, .right, .bottomLeft, .bottomRight, .centerBottom, .centerHorizontally:
            constraints.append(anchorBottomEdge(of: view, in: superview, padding: padding.bottom, safeArea: safeArea))
        default:
            constraints.append(limitBottomEdge(of: view, in: superview, padding: padding.bottom, safeArea: safeArea))
        }

        // right
        switch self {
        case .fill, .right, .top, .bottom, .topRight, .bottomRight, .centerRight, .centerVertically:
            constraints.append(anchorRightEdge(of: view, in: superview, padding: padding.right, safeArea: safeArea))
        default:
            constraints.append(limitRightEdge(of: view, in: superview, padding: padding.right, safeArea: safeArea))
        }

        // center
        switch self {
        case .center:
            constraints.append(view.centerYAnchor.constraint(equalTo: superview.centerYAnchor))
            constraints.append(view.centerXAnchor.constraint(equalTo: superview.centerXAnchor))

        case .centerLeft, .centerRight, .centerVertically:
            constraints.append(view.centerYAnchor.constraint(equalTo: superview.centerYAnchor))

        case .centerTop, .centerBottom, .centerHorizontally:
            constraints.append(view.centerXAnchor.constraint(equalTo: superview.centerXAnchor))
        default:
            break
        }

        NSLayoutConstraint.activate(constraints)
    }

    func anchorLeftEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.leftAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.leftAnchor
        }
        let anchor = view.leftAnchor.constraint(equalTo: superviewAnchor, constant: padding)
        anchor.priority = .required
        return anchor
    }

    func limitLeftEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.leftAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.leftAnchor
        }
        let anchor = view.leftAnchor.constraint(greaterThanOrEqualTo: superviewAnchor, constant: padding)
        anchor.priority = .defaultHigh
        return anchor
    }

    func anchorTopEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.topAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.topAnchor
        }
        let anchor = view.topAnchor.constraint(equalTo: superviewAnchor, constant: padding)
        anchor.priority = .required
        return anchor
    }

    func limitTopEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.topAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.topAnchor
        }
        let anchor = view.topAnchor.constraint(greaterThanOrEqualTo: superviewAnchor, constant: padding)
        anchor.priority = .defaultHigh
        return anchor
    }

    func anchorBottomEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.bottomAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.bottomAnchor
        }
        let anchor = view.bottomAnchor.constraint(equalTo: superviewAnchor, constant: -padding)
        anchor.priority = .required
        return anchor
    }

    func limitBottomEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.bottomAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.bottomAnchor
        }
        let anchor = view.bottomAnchor.constraint(lessThanOrEqualTo: superviewAnchor, constant: -padding)
        anchor.priority = .defaultHigh
        return anchor
    }

    func anchorRightEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.rightAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.rightAnchor
        }
        let anchor = view.rightAnchor.constraint(equalTo: superviewAnchor, constant: -padding)
        anchor.priority = .required
        return anchor
    }

    func limitRightEdge(of view: UIView, in superview: UIView, padding: CGFloat, safeArea: Bool) -> NSLayoutConstraint {
        var superviewAnchor = superview.rightAnchor
        if #available(iOS 11.0, *), safeArea {
            superviewAnchor = superview.safeAreaLayoutGuide.rightAnchor
        }
        let anchor = view.rightAnchor.constraint(lessThanOrEqualTo: superviewAnchor, constant: -padding)
        anchor.priority = .defaultHigh
        return anchor
    }

}
