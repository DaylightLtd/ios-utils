//
//  UITableView+Extensions.swift
//  DaylightUtils
//
//  Created by Ivan Fabijanovic on 21/06/2018.
//  Copyright © 2018 Daylight. All rights reserved.
//

import UIKit

extension Utils where Base: UITableView {
    public func dequeueReusableHeaderFooterView<T: UIView>(withIdentifier identifier: String) -> T {
        guard let view = self.base.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Invalid reusable header/footer view type")
        }
        return view
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = self.base.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Invalid reusable cell type")
        }
        return cell
    }
}
