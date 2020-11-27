
import Foundation
import RxSwift

class ProfileViewModel {
    let sessionService: SessionService
    
    let signOut = PublishSubject<Void>()
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
}
