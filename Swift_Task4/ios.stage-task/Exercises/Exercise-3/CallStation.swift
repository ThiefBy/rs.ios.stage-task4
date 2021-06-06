import Foundation

final class CallStation {
    private var userStore: Set<User> = []
    private var callsStore:[UUID: Call] = [:]
}

extension CallStation: Station {
    func users() -> [User] {
        return Array(self.userStore)
    }
    
    func add(user: User) {
        if !self.userStore.contains(user){
            self.userStore.insert(user)
        }
    }
    
    fileprivate func updateStatus(_ call: Call, _ status: CallStatus) {
        self.callsStore[call.id]?.status = status
    }
    
    func remove(user: User) {
        let callFromStore = self.currentCall(user: user)
        if let call = callFromStore {
            updateStatus(call, CallStatus.ended(reason: .error))
        }
        
        self.userStore.remove(user)
    }
    
    func isUserBusy(user: User) -> Bool{
        let currentCall = self.currentCall(user: user)
        return currentCall != nil && (currentCall?.status == CallStatus.talk || (currentCall?.status == CallStatus.calling && currentCall?.outgoingUser == user))
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from, to):
            if !self.userStore.contains(from)
            {
                return nil
            }
            
            var call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .calling)
            
            if self.userStore.contains(to) {
                call.status = isUserBusy(user: to) ? .ended(reason: .userBusy) : call.status
            }
            else {
                call.status = .ended(reason: .error)
            }
            
            self.callsStore[call.id] = call
            return call.id
        case let .answer(from):
            let callFromStore = self.currentCall(user: from)
            if let call = callFromStore {
                updateStatus(call, CallStatus.talk)
                return call.id
            }
            
            return nil
        case let .end(from):
            let callFromStore = self.currentCall(user: from)
            if let call = callFromStore {
                let reason = call.status == CallStatus.talk ? CallEndReason.end: CallEndReason.cancel
                updateStatus(call,.ended(reason: reason))
                return call.id
            }
            return nil
        }
    }
    
    func calls() -> [Call] {
        return Array(self.callsStore.values)
    }
    
    func calls(user: User) -> [Call] {
        return callsStore.values.filter {call in call.outgoingUser == user || call.incomingUser == user }
    }
    
    func call(id: CallID) -> Call? {
        return self.callsStore[id]
    }
    
    func currentCall(user: User) -> Call? {
        return callsStore.values.first { call in (call.outgoingUser == user || call.incomingUser == user) && (call.status == .talk || call.status == .calling)
        }
    }
}
