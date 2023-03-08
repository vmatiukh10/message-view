//
//  Event.swift
//  MessageController
//
//  Created by Volodymyr Matiukh on 08.03.2023.
//

/// Рішення використане з https://habr.com/ru/company/tinkoff/blog/509014/

import Foundation

final class Event<Args> {
    // Тут живут подписчики на событие и обработчики этого события
    private var handlers: [Weak<AnyObject>: (Args) -> Void] = [:]

    func subscribe<Subscriber: AnyObject>(
        _ subscriber: Subscriber,
        handler: @escaping (Subscriber, Args) -> Void) {

        // Формируем ключ
        let key = Weak<AnyObject>(subscriber)
        // Почистим массив обработчиков от мертвых объектов, чтобы не засорять память
        handlers = handlers.filter { $0.key.isAlive }
        // Создаем обработчик события
        handlers[key] = {
            [weak subscriber] args in
            // Захватываем подписчика слабой ссылкой и вызываем обработчик,
            // только если подписчик жив
            guard let subscriber = subscriber else { return }
            // Исправляем ошибку одновременного доступа на чтение и запись в одном потоке. Хэндлер всегда будет выполняться в основном потоке
            DispatchQueue.main.async {
                handler(subscriber, args)
            }
        }
    }

    func unsubscribe(_ subscriber: AnyObject) {
        // Отписываемся от события, удаляя соответствующий обработчик из словаря
        let key = Weak<AnyObject>(subscriber)
        handlers[key] = nil
    }

    func raise(_ args: Args) {
        // Получаем список обработчиков с живыми подписчиками
        let aliveHandlers = handlers.filter { $0.key.isAlive }
        // Для всех живых подписчиков выполняем код их обработчиков событий
        aliveHandlers.forEach { $0.value(args) }
    }
}

extension Event where Args == Void {
    func subscribe<Subscriber: AnyObject>(
        _ subscriber: Subscriber,
        handler: @escaping (Subscriber) -> Void) {

        subscribe(subscriber) { this, _ in
            handler(this)
        }
    }

    func raise() {
        raise(())
    }
}
