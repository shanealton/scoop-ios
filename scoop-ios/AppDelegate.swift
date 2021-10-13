//
//  AppDelegate.swift
//  scoop-ios
//
//  Created by Shane Alton on 10/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.rootViewController = UINavigationController(rootViewController: HomeController())
        return true
    }
}

