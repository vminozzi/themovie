//
//  UITableViewCell+Extension.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    class func createCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath) -> T {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T ?? T()
    }
}
