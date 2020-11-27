
import Foundation

typealias UnsubscribeMessagerHandler = () -> Void

protocol IMessangerSubcribeComplition {
    var id: UUID { get }
    func execute(_ object: Message)
}

struct MessangerSubcribeComplition<T:Message>: IMessangerSubcribeComplition, Equatable {
    var id: UUID = UUID()
    let comletion: (T) -> Void
    
    func execute(_ object: Message) {
        guard let message = object as? T else { return }
        comletion(message)
    }
    
    static func ==(lhs: MessangerSubcribeComplition<T>, rhs: MessangerSubcribeComplition<T>) -> Bool {
        lhs.id == rhs.id
    }
}


protocol IMessager {
    func subscribe<T:Message>(_ type: T.Type, completion:  MessangerSubcribeComplition<T>) -> UnsubscribeMessagerHandler
    func publish<T:Message>(message: T)
}


class Message {       
    static var name: String {
        get {
            return String(describing: self)
        }
    }
}
