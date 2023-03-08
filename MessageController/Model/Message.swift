//
//  Message.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import Foundation

struct Message: Codable {
    let id: String
    let created: Date
    let body: String
}
