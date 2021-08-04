//
//  TableWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

//open class TableViewTest {
//
//    @State var items: [String] = []
//
//    func builder() -> Widget {
//        return TableWidget([
//            TableSectionWidget([
//                LabelWidget("Section 1 Row 1"),
//                LabelWidget("Section 1 Row 2"),
//                LabelWidget("Section 1 Row 2")
//            ]),
//            TableSectionWidget([
//                LabelWidget("Section 2 Row 1"),
//                LabelWidget("Section 2 Row 2")
//            ]),
//            DynamicSectionWidget<String>($items) {
//                LabelWidget($0)
//            }
//        ])
//
//    }
//}

public protocol WidgetUpdatable: class {
    func updated()
}

public protocol WidgetTableViewCellProviding {
    func cell(for tableView: UITableView, with context: WidgetContext) -> UITableViewCell
}

//public protocol CollectionViewCellProviding {
//    func cell(for collectionView: UICollectionView, with context: WidgetContext) -> UICollectionViewCell
//}

open class TableWidget
    : NSObject
    , Widget
    , WidgetViewModifying
    , WidgetPadding
    , WidgetUpdatable {

    public override var debugDescription: String { "TableWidget()" }

    public weak var tableView: UITableView!

    public var sections: [BaseTableSection]

    public var modifiers = WidgetModifiers()
    public var context: WidgetContext!

    public var grouped: UITableView.Style?
    public var selectionHandler: ((_ context: WidgetContext, _ indexPath: IndexPath) -> Void)?
    public var initialRefresh: Bool = false
    public var refreshHandler: ((_ context: WidgetContext) -> Void)?

    public init(_ sections: [BaseTableSection] = []) {
        self.sections = sections
        super.init()
    }

    public func build(with context: WidgetContext) -> UIView {

        let grouped = self.grouped ?? (sections.count > 1 ? .grouped : .plain)

        let view = WidgetTableView(frame: .zero, style: grouped)

        self.context = modifiers.modified(context, for: view)
            .putWeak(view)

        sections.forEach {
            $0.parent = self
            $0.context = self.context
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            view.insetsLayoutMarginsFromSafeArea = false
        }
        view.estimatedRowHeight = 44.0
        
        view.tableViewWidget = self
        view.dataSource = self
        view.delegate = self
        view.register(RowWidgetCustomCell.self, forCellReuseIdentifier: String(describing: RowWidgetCustomCell.self))

        if #available(iOS 11.0, *) {
            view.insetsContentViewsToSafeArea = false
        } // kill default behavior and left safearea modifier handle things.

        if let refreshHandler = refreshHandler {
            view.enablePullToRefresh(refreshHandler)
            if initialRefresh {
                DispatchQueue.main.async {
                    view.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
                    view.refreshControl?.beginRefreshing()
                    view.refreshControl?.sendActions(for: .valueChanged)
                }
            }
        }

        modifiers.apply(to: view, with: self.context)

        self.tableView = view

        return view
    }

    public func onRefresh(initialRefresh: Bool = false, handler: @escaping ((_ context: WidgetContext) -> Void)) -> Self {
        self.initialRefresh = initialRefresh
        self.refreshHandler = handler
        return self
    }

    public func onSelect(_ selectionHandler: @escaping (_ context: WidgetContext, _ indexPath: IndexPath) -> Void) -> Self {
        self.selectionHandler = selectionHandler
        return self
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UITableView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

    public func updated() {
        tableView?.reloadData()
        tableView?.refreshControl?.endRefreshing()
    }

}

extension TableWidget: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cell(for: tableView, at: indexPath.row)
    }

}

extension TableWidget: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard sections.indices.contains(indexPath.section) else { return }
        if !sections[indexPath.section].didSelectRowAt(indexPath: indexPath) {
            selectionHandler?(context, indexPath)
        }
    }

}

extension WidgetContext {
    public var tableView: UITableView? {
        return getWeak(WidgetTableView.self)
    }
}


fileprivate class WidgetTableView: UITableView {

    public var tableViewWidget: TableWidget?
    public var refresh: ((_ context: WidgetContext) -> Void)?

    open func enablePullToRefresh(_ refresh: @escaping (_ context: WidgetContext) -> Void) {
        self.refresh = refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(callRefresh(_:)), for: .valueChanged)
    }

    @objc private func callRefresh(_ sender: Any) {
        if let widget = tableViewWidget {
            refresh?(widget.context)
        }
    }

}
