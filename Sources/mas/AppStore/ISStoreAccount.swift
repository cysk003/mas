//
//  ISStoreAccount.swift
//  mas
//
//  Created by Andrew Naylor on 22/08/2015.
//  Copyright (c) 2015 Andrew Naylor. All rights reserved.
//

import CommerceKit
import PromiseKit
import StoreFoundation

private let timeout = 30.0

extension ISStoreAccount: StoreAccount {
    static var primaryAccount: Promise<ISStoreAccount> {
        if #available(macOS 10.13, *) {
            return race(
                Promise { seal in
                    ISServiceProxy.genericShared().accountService
                        .primaryAccount { storeAccount in
                            seal.fulfill(storeAccount)
                        }
                },
                after(seconds: timeout)
                    .then {
                        Promise(error: MASError.notSignedIn)
                    }
            )
        }

        return .value(CKAccountStore.shared().primaryAccount)
    }

    static func signIn(appleID: String, password: String, systemDialog: Bool) -> Promise<ISStoreAccount> {
        // swift-format-ignore: UseEarlyExits
        if #available(macOS 10.13, *) {
            // Signing in is no longer possible as of High Sierra.
            // https://github.com/mas-cli/mas/issues/164
            return Promise(error: MASError.notSupported)
            // swiftlint:disable:next superfluous_else
        } else {
            return
                primaryAccount
                .then { account -> Promise<ISStoreAccount> in
                    if account.isSignedIn {
                        return Promise(error: MASError.alreadySignedIn(asAppleID: account.identifier))
                    }

                    let password =
                        password.isEmpty && !systemDialog
                        ? String(validatingUTF8: getpass("Password: ")) ?? ""
                        : password

                    guard !password.isEmpty || systemDialog else {
                        return Promise(error: MASError.noPasswordProvided)
                    }

                    let context = ISAuthenticationContext(accountID: 0)
                    context.appleIDOverride = appleID

                    let signInPromise =
                        Promise<ISStoreAccount> { seal in
                            let accountService = ISServiceProxy.genericShared().accountService
                            accountService.setStoreClient(ISStoreClient(storeClientType: 0))
                            accountService.signIn(with: context) { success, storeAccount, error in
                                if success, let storeAccount {
                                    seal.fulfill(storeAccount)
                                } else {
                                    seal.reject(MASError.signInFailed(error: error as NSError?))
                                }
                            }
                        }

                    if systemDialog {
                        return signInPromise
                    }

                    context.demoMode = true
                    context.demoAccountName = appleID
                    context.demoAccountPassword = password
                    context.demoAutologinMode = true

                    return race(
                        signInPromise,
                        after(seconds: timeout)
                            .then {
                                Promise(error: MASError.signInFailed(error: nil))
                            }
                    )
                }
        }
    }
}
