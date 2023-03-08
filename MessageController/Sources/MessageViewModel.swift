//
//  MessageViewModel.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

import Foundation

protocol MessageSendingProtocol: AnyObject {
    func messageDidSend()
}

class MessageViewModel {
    
    private let messageStore = MessageStore()
    
    @Observable
    var messages: [Message] = []
    
    @Observable
    var isFetchingData: Bool = false
    
    weak var delegate: MessageSendingProtocol?
    
    func loadMessages() {
        messageStore.loadMessages { [weak self] result in
            guard let self = self, case .success(let messages) = result else {
                return
            }
            self.insertMessages(messages)
        }
    }
    
    private func insertMessages(_ messages: [Message]) {
        guard !self.messages.isEmpty else {
            self.messages = messages
            return
        }
        if let lastMessage = messages.last, let insetIndex = self.messages.firstIndex(where: { $0.created < lastMessage.created }) {
            self.messages.insert(contentsOf: messages, at: insetIndex)
        } else {
            self.messages.append(contentsOf: messages)
        }
    }
    
    func send(message: String) {
        messageStore.send(message: message) { [weak self] result in
            if case .success(let message) = result {
                self?.messages.append(message)
                self?.delegate?.messageDidSend()
            }
        }
    }
}
