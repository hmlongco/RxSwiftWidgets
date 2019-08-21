//
//  RowWidget.swift
//  RxSwiftWidgets
//
//  Created by Michael Long on 8/18/19.
//

import UIKit
import RxSwift
import RxCocoa

public struct RowWidget: Widget
    , TableViewCellProviding {

    public var title: String?
    public var subtitle: String?

    public init(_ title: String?, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    public func build(with context: WidgetContext) -> UIView {
        fatalError()
    }

    public func cell(for tableView: UITableView, with context: WidgetContext) -> UITableViewCell {
        var reusableCellID: String!
        if subtitle == nil {
            reusableCellID = "RowWidgetCell"
            tableView.register(RowWidgetCell.self, forCellReuseIdentifier: reusableCellID)
        } else {
            reusableCellID = "SubtitleRowWidgetCell"
            tableView.register(SubtitleRowWidgetCell.self, forCellReuseIdentifier: reusableCellID)
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellID) {
            configure(cell: cell, with: context)
            return cell
        }
        return UITableViewCell()
    }

    public func configure(cell: UITableViewCell, with context: WidgetContext) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
    }

}

public class RowWidgetCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class SubtitleRowWidgetCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct MasterDetailRowWidget {}

struct CustomRowWidget {}
