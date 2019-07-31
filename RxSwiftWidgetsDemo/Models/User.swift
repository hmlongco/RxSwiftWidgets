//
//  User.swift
//  Widgets
//
//  Created by Michael Long on 3/13/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

struct User {
    let name: String?
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    let email: String?
    let initials: String?
}

extension User {
    static var users = [
        User(name: "Michael Long", address: "2310 S 178th", city: "Omaha", state: "NE", zip: "68130", email: "hml@gmail.com", initials: "ML"),
        User(name: "Frank Hardy", address: "190 W Dixon", city: "Los Angles", state: "CA", zip: "90210", email: "fhardy@gmail.com", initials: "FH"),
        User(name: "Joesph Hardy", address: "190 W Dixon", city: "Los Angles", state: "CA", zip: "90210", email: "jhardyverylongemailaddress@gmail.com", initials: "JH"),
        User(name: "Tom Swift", address: "33 Appleton Way", city: "New York", state: "NE", zip: "10101", email: "tswift@gmail.com", initials: "TS"),
        User(name: "Jonathan Quest", address: "General Delivery", city: "Palm Key", state: "FL", zip: "33480", email: "jquest@hb.com", initials: "JQ")
    ]
}

extension User {

    static var loginOrError = true

    static func login(_ username: String, _ password: String) -> Observable<User> {
        return .create({ (results) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if User.loginOrError {
                    results.onNext(User.users[0])
                    results.onCompleted()
                } else {
                    results.onError(GenericError.description("Unable to login at this time. Please try again later."))
                }
                User.loginOrError.toggle()
            })
            return Disposables.create()
        })
    }

}
