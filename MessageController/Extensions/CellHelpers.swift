//
//  Cells+Extension.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {
            register(UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
    
    func dequeue<T: UITableViewCell>(cellForItemAt indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
