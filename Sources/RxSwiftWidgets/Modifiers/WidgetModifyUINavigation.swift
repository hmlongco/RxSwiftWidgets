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

extension WidgetModifying {

    public func navigationBar(title: String, hidden: Bool? = nil) -> Self {
        _navigationBar(title: title, hidden: hidden)
    }

    @available(iOS 11.0, *)
    public func navigationBar(title: String, preferLargeTitles: Bool? = nil, hidden: Bool? = nil) -> Self {
        _navigationBar(title: title, preferLargeTitles: preferLargeTitles, hidden: hidden)
    }

    private func _navigationBar(title: String, preferLargeTitles: Bool? = nil, hidden: Bool? = nil) -> Self {
        modified(WidgetModifierBlock<UIView> { _, context in
            if let vc = context.viewController {
                vc.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
                    .subscribe(onNext: { _ in
                        context.viewController?.title = title
                        guard let nav = context.navigator?.navigationController else { return }
                        if let largeTitles = preferLargeTitles, #available(iOS 11.0, *) {
                            nav.navigationBar.prefersLargeTitles = largeTitles
                        }
                        if let hidden = hidden {
                            nav.isNavigationBarHidden = hidden
                        }
                    })
                    .disposed(by: context.disposeBag)
            }
        })
    }

}
