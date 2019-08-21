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

public class BaseSectionWidget: Widget
    , WidgetUpdatable {

    public weak var parent: WidgetUpdatable? = nil

    public var widgets: [Widget]
    public var defaultCellPadding = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

    fileprivate init(_ widgets: [Widget]) {
        self.widgets = widgets
    }

    public func build(with context: WidgetContext) -> UIView {
        fatalError()
    }

    public var count: Int {
        widgets.count
    }

    public func cell(for tableView: UITableView, at row: Int, with context: WidgetContext) -> UITableViewCell {
        guard widgets.indices.contains(row) else {
            return UITableViewCell()
        }
        if let provider = widgets[row] as? TableViewCellProviding {
            return provider.cell(for: tableView, with: context)
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as? WidgetTableViewCell {
            cell.reset(widgets[row], with: context, padding: defaultCellPadding)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    public func updated() {
        parent?.updated()
    }

}

public class SectionWidget: BaseSectionWidget {

//    internal var cache = [Int:UITableViewCell]()

    public override init(_ widgets: [Widget] = []) {
        super.init(widgets)
    }

    public override func cell(for tableView: UITableView, at row: Int, with context: WidgetContext) -> UITableViewCell {
//        if let cell = cache[row] {
//            return cell
//        }
        let cell = super.cell(for: tableView, at: row, with: context)
//        cache[row] = cell
        return cell
    }

}

public class DynamicSectionWidget<Item>: BaseSectionWidget {

    public init<Item, O:ObservableElement>(_ items: O, builder: @escaping (_ item: Item) -> Widget) where O.Element == [Item] {
        super.init([])
    }

}
