//
//  Weak.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import Foundation

final class Weak<T: AnyObject> {

    private let id: ObjectIdentifier?
    private(set) weak var value: T?

    var isAlive: Bool {
        return value != nil
    }

    init(_ value: T?) {
        self.value = value
        if let value = value {
            id = ObjectIdentifier(value)
        } else {
            id = nil
        }
    }
}

extension Weak: Hashable {
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        if let id = id {
            hasher.combine(id)
        }
    }
}

