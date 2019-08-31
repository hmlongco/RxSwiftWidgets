//
//  TableCellWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 8/18/19.
//

import UIKit
import RxSwift
import RxCocoa

public protocol Hideable {

}

extension Widgets {
    public enum TableCellCaching {
        case auto
        case cache
        case none
    }
}

public class TableCellWidget: Widget
    , WidgetTableViewCellProviding
    , WidgetViewModifying
    , WidgetPadding {

    public var title: String?
    public var detail: String?
    public var widget: Widget?
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var caching = Widgets.TableCellCaching.auto
    public var reusableCellID: String
    public var cellType: AnyClass
    public var modifiers = WidgetModifiers()

    public init(_ title: String?) {
        self.title = title
        self.reusableCellID = String(describing: RowWidgetTitleCell.self)
        self.cellType = RowWidgetTitleCell.self
    }

    public init(_ title: String?, subtitle: String?) {
        self.title = title
        self.detail = subtitle
        self.reusableCellID = String(describing: RowWidgetSubtitleCell.self)
        self.cellType = RowWidgetSubtitleCell.self
    }

    public init(_ title: String?, value: String?) {
        self.title = title
        self.detail = value
        self.reusableCellID = String(describing: RowWidgetValueCell.self)
        self.cellType = RowWidgetValueCell.self
    }

    public init(_ widget: Widget) {
        self.widget = widget
        self.reusableCellID = String(describing: WidgetTableViewCell.self)
        self.cellType = WidgetTableViewCell.self
    }

    public func build(with context: WidgetContext) -> UIView {
        fatalError("")
    }

    public func cell(for tableView: UITableView, with context: WidgetContext) -> UITableViewCell {
        tableView.register(cellType, forCellReuseIdentifier: reusableCellID)
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellID) {
            configure(cell: cell, with: context)
            return cell
        }
        return UITableViewCell()
    }

    public func configure(cell: UITableViewCell, with context: WidgetContext) {
        if let widget = widget, let cell = cell as? WidgetTableViewCell {
            cell.reset(widget, with: context, padding: modifiers.padding ?? UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        } else {
            cell.textLabel?.text = title
            cell.textLabel?.textColor = context.theme.color.text
            cell.textLabel?.font = context.theme.font.body
            cell.detailTextLabel?.text = detail
            cell.detailTextLabel?.textColor = context.theme.color.secondaryText
        }
        cell.accessoryType = accessoryType
        modifiers.apply(to: cell, with: context)
    }

    public func accessoryType(_ accessoryType: UITableViewCell.AccessoryType) -> Self {
        self.accessoryType = accessoryType
        return self
    }

    public func caching(_ caching: Widgets.TableCellCaching) -> Self {
        self.caching = caching
        return self
    }

}

fileprivate class RowWidgetTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class RowWidgetSubtitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class RowWidgetValueCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CustomRowWidget {}
