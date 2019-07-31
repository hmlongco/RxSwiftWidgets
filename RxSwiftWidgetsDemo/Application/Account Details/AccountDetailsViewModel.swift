//
//  AccountDetailsViewModel.swift
//  RxSwiftWidgetsDemo
//
//  Created by Michael Long on 7/31/19.
//

import UIKit
import RxSwift
import RxCocoa

class AccountDetailsViewModel {

    var loading = BehaviorRelay(value: true)

    lazy var title = accountInformation
        .map { $0.name }

    lazy var accountDetails = accountInformation
        .map { Array($0.details.prefix(2)) }
    
    lazy var paymentDetails = accountInformation
        .map { Array($0.details.dropFirst(2)) }

    lazy var footnotes = accountInformation
        .map { $0.footnotes }

    private var accountInformation = PublishSubject<AccountInformation>()

    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.accountInformation.onNext(AccountInformation.sample)
            self.loading.accept(false)
        }
    }
    
}
