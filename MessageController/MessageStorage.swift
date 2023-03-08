//
//  MessageStorage.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import Foundation

class MessageStore {
    
    func loadMessages(completion: @escaping (Result<[Message], Error>) -> ()) {
        DispatchQueue.global().async {
            do {
                let localUrl = Bundle.main.url(forResource: "messages_mock", withExtension: "json")
                let data = try Data(contentsOf: localUrl!)
                let jsonDecoder = JSONDecoder()
                let messages = try jsonDecoder.decode([Message].self, from: data)
                let sortedMessages = messages.sorted(by: { $0.created < $1.created })
                DispatchQueue.main.async {
                    completion(.success(sortedMessages))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func send(message: String, completion: @escaping (Result<Message, Error>) -> ()) {
        DispatchQueue.global().async {
            let message = Message(id: UUID().uuidString, created: Date(), body: message)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
    }
}
