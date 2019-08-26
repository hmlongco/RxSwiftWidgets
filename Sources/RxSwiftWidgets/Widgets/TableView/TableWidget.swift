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

//public class TableViewTest {
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

public protocol TableViewCellProviding {
    func cell(for tableView: UITableView, with context: WidgetContext) -> UITableViewCell
}

//public protocol CollectionViewCellProviding {
//    func cell(for collectionView: UICollectionView, with context: WidgetContext) -> UICollectionViewCell
//}

public class TableWidget
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

    public init(_ sections: [BaseTableSection] = []) {
        self.sections = sections
        super.init()
        sections.forEach { $0.parent = self }
    }

    public func build(with context: WidgetContext) -> UIView {

        let grouped = self.grouped ?? (sections.count > 1 ? .grouped : .plain)

        let view = WidgetTableView(frame: .zero, style: grouped)

        self.context = modifiers.modified(context, for: view)
            .putWeak(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = false
        
        view.tableViewWidget = self
        view.dataSource = self
        view.delegate = self
        view.register(WidgetTableViewCell.self, forCellReuseIdentifier: String(describing: WidgetTableViewCell.self))

        if #available(iOS 11.0, *) {
            view.insetsContentViewsToSafeArea = false
        } // kill default behavior and left safearea modifier handle things.

        modifiers.apply(to: view, with: self.context)

        self.tableView = view

        return view
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
        return sections[indexPath.section].cell(for: tableView, at: indexPath.row, with: context)
    }

}

extension TableWidget: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard sections.indices.contains(indexPath.section) else { return }
        if !sections[indexPath.section].didSelectRowAt(indexPath: indexPath, with: context) {
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

}

open class WidgetTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()

    override open func prepareForReuse() {
        disposeBag = DisposeBag()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    open func reset(_ widget: Widget, with context: WidgetContext, padding: UIEdgeInsets) {
        var context = context
        context.disposeBag = disposeBag
        let view = widget.build(with: context)
        contentView.addConstrainedSubview(view, with: padding)
    }

}
