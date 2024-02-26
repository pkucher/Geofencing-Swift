//
//  AppDelegate.swift
//  CoreLocationPock
//
//  Created by user on 19/02/24.
//
import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDoFSQKJ_F7WoY8cvKSSK4o4stYHjxEA9w")
        let navigationController = UINavigationController(rootViewController: AddressViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
