//
//  UITableView+Extension.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(["Could not dequeue cell with identifier:", T.reuseIdentifier].joined(separator: " "))
        }

        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError(["Could not dequeue cell with identifier:", T.reuseIdentifier].joined(separator: " "))
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError(["Could not dequeue cell with identifier:", T.reuseIdentifier].joined(separator: " "))
        }

        return view
    }
}
