//
//  AppDelegate.swift
//  MovieDatabase
//
//  Created by Michael Detrick on 9/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = .init(frame: UIScreen.main.bounds)
    let controller = MovieDatabaseViewController()
    let navigation = UINavigationController(rootViewController: controller)
    window?.rootViewController = navigation
    window?.makeKeyAndVisible()

    return true
  }

}

