//
//  TableViewSectionWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 7/10/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

open class BaseTableSection
    : Widget
    , WidgetUpdatable {

    public weak var parent: WidgetUpdatable? = nil

    public var context: WidgetContext!
    public var defaultCellPadding = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

    fileprivate init() {}

    public func build(with context: WidgetContext) -> UIView {
        fatalError()
    }

    public var count: Int {
        return 0
    }

    public func cell(for tableView: UITableView, at row: Int) -> UITableViewCell {
        guard let widget = getWidget(at: row) else {
            return UITableViewCell()
        }
        if let provider = widget as? WidgetTableViewCellProviding {
            return provider.cell(for: tableView, with: context)
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RowWidgetCustomCell.self)) as? RowWidgetCustomCell {
            cell.reset(widget, with: context, padding: defaultCellPadding)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    public func getWidget(at row: Int) -> WidgetViewType? {
        return nil
    }

    public func didSelectRowAt(indexPath: IndexPath) -> Bool {
        fatalError("abstract class")
    }

    public func updated() {
        parent?.updated()
    }

}

open class TableSectionWidget: BaseTableSection {

    public var widgets: [WidgetViewType] {
        didSet { updated() }
    }

    public var cache: [Int:UITableViewCell] = [:]
    public var caching = Widgets.TableCellCaching.auto
    public var selectionHandler: ((_ context: WidgetContext, _ indexPath: IndexPath) -> Void)?

    public init(_ widgets: [WidgetViewType] = []) {
        self.widgets = widgets
        super.init()
    }

    public override var count: Int {
        return widgets.count
    }

    public override func cell(for tableView: UITableView, at row: Int) -> UITableViewCell {
        guard let widget = getWidget(at: row) else {
            return UITableViewCell()
        }
        if let widget = widget as? TableCellWidget {
            switch (caching, widget.caching) {
            case (_, .none), (.none, _):
                return super.cell(for: tableView, at: row)
            default:
                if let cell = cache[row] {
                    return cell
                }
                let cell = super.cell(for: tableView, at: row)
                cache[row] = cell
                return cell
            }
        } else {
            return super.cell(for: tableView, at: row)
        }
    }

    public override func getWidget(at row: Int) -> WidgetViewType? {
        guard widgets.indices.contains(row) else { return nil }
        return widgets[row]
    }

    public func caching(_ caching: Widgets.TableCellCaching) {
        self.caching = caching
    }

    public func onSelect(_ selectionHandler: @escaping (_ context: WidgetContext, _ indexPath: IndexPath) -> Void) -> Self {
        self.selectionHandler = selectionHandler
        return self
    }

    public override func didSelectRowAt(indexPath: IndexPath) -> Bool {
        if let selectionHandler = selectionHandler {
            selectionHandler(context, indexPath)
            return true
        }
        return false
    }

}

open class DynamicTableSectionWidget<Item>: BaseTableSection {

    private var builder: (_ item: Item) -> WidgetViewType
    private var items: [Item] = []
    private var selectionHandler: ((_ context: WidgetContext, _ indexPath: IndexPath, _ item: Item) -> Void)?
    private var disposeBag = DisposeBag()

    public init<O:ObservableElement>(_ items: O, builder: @escaping (_ item: Item) -> WidgetViewType) where O.Element == [Item] {
        self.builder = builder
        super.init()
        items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (items) in
                self?.items = items
                self?.updated()
            })
            .disposed(by: disposeBag)
    }

    public override var count: Int {
        return items.count
    }

    public override func getWidget(at row: Int) -> WidgetViewType? {
        guard items.indices.contains(row) else { return nil }
        return builder(items[row])
    }

    public func onSelect(_ selectionHandler: @escaping (_ context: WidgetContext, _ indexPath: IndexPath, _ item: Item) -> Void) -> Self {
        self.selectionHandler = selectionHandler
        return self
    }

    public override func didSelectRowAt(indexPath: IndexPath) -> Bool {
        guard items.indices.contains(indexPath.row) else { return false }
        if let selectionHandler = selectionHandler {
            selectionHandler(context, indexPath, items[indexPath.row])
            return true
        }
        return false
    }

}
