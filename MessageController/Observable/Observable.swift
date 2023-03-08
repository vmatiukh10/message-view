//
//  Observable.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import Foundation

@propertyWrapper
struct Observable<T> {
    let projectedValue = Event<T>()

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    var wrappedValue: T {
        didSet {
            projectedValue.raise(wrappedValue)
        }
    }
}
