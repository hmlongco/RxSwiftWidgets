//
//  AccountInformation.swift
//  Widgets
//
//  Created by Michael Long on 3/28/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

struct AccountInformation {

    struct AccountDetails {
        let name: String
        let value: String
    }

    let name: String
    let footnotes: String
    let details: [AccountDetails]

    static let sample = AccountInformation(
        name: "Michael's Credit Card",
        footnotes: "Account balances are subject to processing delays and may not accurately represent the current balance.",
        details: [
            AccountDetails(name: "Account Type", value: "Visa Card"),
            AccountDetails(name: "Current Balance", value: "$12,346.23"),
            AccountDetails(name: "Balance Due", value: "$10,246.39"),
            AccountDetails(name: "Minimum Payment Due", value: "$146.23"),
            AccountDetails(name: "Last Payment Amount", value: "$5,000.00"),
            AccountDetails(name: "Interest Charged", value: "$233.22"),
            AccountDetails(name: "Payment Due", value: "03/12/19"),
            AccountDetails(name: "APR", value: "17.23%"),
        ]
    )

    static var dataOrError = true

    static func load() -> Observable<AccountInformation> {
        return .create({ (results) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if AccountInformation.dataOrError {
                    results.onNext(AccountInformation.sample)
                    results.onCompleted()
                } else {
                    results.onError(GenericError.description("Unable to obtain account information at this time. Please try again later."))
                }
                AccountInformation.dataOrError.toggle()
            })
            return Disposables.create()
        })
    }

}
