//
//  UserService.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/16/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import RealmSwift

final class UserService {
    public static let shared = UserService()
    private init() {}
    
    func add(name: String, callBack: ((Bool) -> Void)?) {
        try! RealmService.shared.reference().write {
            let user = User()
            user.name = name
            RealmService.shared.reference().add(user)
            callBack?(true)
        }
    }
    
    func update(user: User, name: String, callBack: ((Bool) -> Void)?) {
        try! RealmService.shared.reference().write {
            user.name = name
            RealmService.shared.reference().add(user, update: true)
        }
        callBack?(true)
    }
    
    func createDefaultUser() {
        if RealmService.shared.reference().objects(User.self).count == 0 {
            add(name: "You", callBack: nil)
        }
    }
    
    func getDefaultUser() -> User {
        guard let user = RealmService.shared.reference().objects(User.self).first else {
            createDefaultUser()
            return RealmService.shared.reference().objects(User.self).first!
        }
        return user
    }
}
