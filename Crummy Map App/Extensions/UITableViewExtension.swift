//
//  UITableViewExtension.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/22/21.
//

import UIKit

// MARK: UITableView Extension

extension UITableView {
    
    /**
    This helper allows us to write cleaner dequeuing calls by taking advantage of Swift
    Generics, and our `reuseIdentifier` class properties in UITableViewCell, to cut out common
    code, and eliminate the optional returned by `dequeueReusableCell(withIdentifier:for:)`.
    ### The old way:
      `guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier(), for: indexPath) as? SearchResultCell else { return UITableViewCell() }`
    ### The new way:
      `let cell: SearchResultCell = tableView.dequeue(for: indexPath)`
    */
    func dequeueReusableCell<T : UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

// MARK: UITableViewCell Extension

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell : ReusableView { }

