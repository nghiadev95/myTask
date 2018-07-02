//
//  RealmService.swift
//  myTask
//
//  Created by Quang Nghia on 7/25/17.
//  Copyright © 2017 Quang Nghia. All rights reserved.
//

import RealmSwift

final class RealmService {
    
    public static let shared = RealmService()
    private let realm: Realm!
    
    private init() {
        realm = try! Realm()
    }
    
    public func reference() -> Realm {
        return realm
    }
}
