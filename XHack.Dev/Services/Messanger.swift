import Foundation


class Messager: IMessager {
    private var subscriptions: [String: [IMessangerSubcribeComplition]] = [:]
        
    func subscribe<T>(_ type: T.Type, completion: MessangerSubcribeComplition<T>) -> UnsubscribeMessagerHandler where T : Message  {
        if subscriptions[type.name] == nil {
            subscriptions[type.name] = []
        }
        subscriptions[type.name]!.append(completion)
        return {
            self.subscriptions[type.name] = self.subscriptions[type.name]?.filter{ $0.id != completion.id }
        }
    }
    
    func publish<T>(message: T) where T : Message {
        let name = T.name
        guard let subscriptions = subscriptions[name] else { return }
        subscriptions.forEach { $0.execute(message)}
    }
}
