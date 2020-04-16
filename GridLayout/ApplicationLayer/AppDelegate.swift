//
//  AppDelegate.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let resolver = LayoutArrangerImpl() as LayoutArranger
        let items = [
            GridItem(tag: "1"),
            GridItem(tag: "2"),
            GridItem(tag: "3"),
            GridItem(tag: "*"),
            GridItem(tag: "4"),
            GridItem(tag: "5"),
            GridItem(tag: "+", rowSpan: 3),
            GridItem(tag: "0", columnSpan: 2),
            GridItem(tag: "6"),
            GridItem(tag: "=", columnSpan: 3),
            GridItem(tag: "-"),
            GridItem(tag: "7"),
            GridItem(tag: "8"),
            GridItem(tag: "9")
        ]
        let arrangement = resolver.arrange(items: items, columnsCount: 4)
        let stringRepresentation = arrangement.description
        print(stringRepresentation)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
