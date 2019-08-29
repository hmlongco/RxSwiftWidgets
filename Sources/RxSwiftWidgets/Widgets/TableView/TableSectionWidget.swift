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

public class BaseTableSection: Widget
    , WidgetUpdatable {

    public weak var parent: WidgetUpdatable? = nil

    public var defaultCellPadding = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

    fileprivate init() {}

    public func build(with context: WidgetContext) -> UIView {
        fatalError()
    }

    public var count: Int {
        return 0
    }

    public func cell(for tableView: UITableView, at row: Int, with context: WidgetContext) -> UITableViewCell {
        guard let widget = getWidget(at: row) else {
            return UITableViewCell()
        }
        if let provider = widget as? TableViewCellProviding {
            return provider.cell(for: tableView, with: context)
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WidgetTableViewCell.self)) as? WidgetTableViewCell {
            cell.reset(widget, with: context, padding: defaultCellPadding)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    public func getWidget(at row: Int) -> Widget? {
        return nil
    }

    public func didSelectRowAt(indexPath: IndexPath, with context: WidgetContext) -> Bool {
        fatalError("abstract class")
    }

    public func updated() {
        parent?.updated()
    }

}

public class TableSectionWidget: BaseTableSection {

    public var widgets: [Widget] {
        didSet { updated() }
    }

    public var cache: [Int:UITableViewCell] = [:]
    public var caching = Widgets.TableCellCaching.auto
    public var selectionHandler: ((_ context: WidgetContext, _ indexPath: IndexPath) -> Void)?

    public init(_ widgets: [Widget] = []) {
        self.widgets = widgets
        super.init()
    }

    public override var count: Int {
        return widgets.count
    }

    public override func cell(for tableView: UITableView, at row: Int, with context: WidgetContext) -> UITableViewCell {
        guard let widget = getWidget(at: row) else {
            return UITableViewCell()
        }
        if let widget = widget as? TableCellWidget {
            switch (caching, widget.caching) {
            case (_, .none), (.none, _):
                return super.cell(for: tableView, at: row, with: context)
            default:
                if let cell = cache[row] {
                    return cell
                }
                let cell = super.cell(for: tableView, at: row, with: context)
                cache[row] = cell
                return cell
            }
        } else {
            return super.cell(for: tableView, at: row, with: context)
        }
    }

    public override func getWidget(at row: Int) -> Widget? {
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

    public override func didSelectRowAt(indexPath: IndexPath, with context: WidgetContext) -> Bool {
        if let selectionHandler = selectionHandler {
            selectionHandler(context, indexPath)
            return true
        }
        return false
    }

}

public class DynamicTableSectionWidget<Item>: BaseTableSection {

    private var builder: (_ item: Item) -> Widget
    private var items: [Item] = []
    private var selectionHandler: ((_ context: WidgetContext, _ indexPath: IndexPath, _ item: Item) -> Void)?
    private var disposeBag = DisposeBag()

    public init<O:ObservableElement>(_ items: O, builder: @escaping (_ item: Item) -> Widget) where O.Element == [Item] {
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

    public override func getWidget(at row: Int) -> Widget? {
        guard items.indices.contains(row) else { return nil }
        return builder(items[row])
    }

    public func onSelect(_ selectionHandler: @escaping (_ context: WidgetContext, _ indexPath: IndexPath, _ item: Item) -> Void) -> Self {
        self.selectionHandler = selectionHandler
        return self
    }

    public override func didSelectRowAt(indexPath: IndexPath, with context: WidgetContext) -> Bool {
        guard items.indices.contains(indexPath.row) else { return false }
        if let selectionHandler = selectionHandler {
            selectionHandler(context, indexPath, items[indexPath.row])
            return true
        }
        return false
    }

}
