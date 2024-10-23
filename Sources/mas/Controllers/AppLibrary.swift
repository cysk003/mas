//
//  AppLibrary.swift
//  mas
//
//  Created by Ben Chatelain on 12/27/18.
//  Copyright © 2018 mas-cli. All rights reserved.
//

import Foundation

/// Utility for managing installed apps.
protocol AppLibrary {
    /// Entire set of installed apps.
    var installedApps: [SoftwareProduct] { get }

    /// Uninstalls an app.
    ///
    /// - Parameter app: App to be removed.
    /// - Throws: Error if there is a problem.
    func uninstallApp(app: SoftwareProduct) throws
}

/// Common logic
extension AppLibrary {
    /// Finds all installed instances of apps whose app ID is `appID`.
    ///
    /// - Parameter appID: app ID for app(s).
    /// - Returns: [SoftwareProduct] of matching apps.
    func installedApps(withAppID appID: AppID) -> [SoftwareProduct] {
        let appID = NSNumber(value: appID)
        return installedApps.filter { $0.itemIdentifier == appID }
    }

    /// Finds all installed instances of apps whose name is `appName`.
    ///
    /// - Parameter appName: Full name of app(s).
    /// - Returns: [SoftwareProduct] of matching apps.
    func installedApps(named appName: String) -> [SoftwareProduct] {
        installedApps.filter { $0.appName == appName }
    }
}
