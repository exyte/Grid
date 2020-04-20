//
//  AppDelegate.swift
//  GridLayout
//
//  Created by Denis Obukhov on 14.04.2020.
//  Copyright © 2020 Denis Obukhov. All rights reserved.
//

import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let resolver = LayoutArrangerImpl() as LayoutArranger
        let items = [
            SpanPreference(item: GridItem(EmptyView(), tag: "1")),
            SpanPreference(item: GridItem(EmptyView(), tag: "2")),
            SpanPreference(item: GridItem(EmptyView(), tag: "3")),
            SpanPreference(item: GridItem(EmptyView(), tag: "*")),
            SpanPreference(item: GridItem(EmptyView(), tag: "4")),
            SpanPreference(item: GridItem(EmptyView(), tag: "5")),
            SpanPreference(item: GridItem(EmptyView(), tag: "+"), span: .init(row: 1, column: 2)),
            SpanPreference(item: GridItem(EmptyView(), tag: "0"), span: .init(row: 2)),
            SpanPreference(item: GridItem(EmptyView(), tag: "6")),
            SpanPreference(item: GridItem(EmptyView(), tag: "="), span: .init(column: 3)),
            SpanPreference(item: GridItem(EmptyView(), tag: "-")),
            SpanPreference(item: GridItem(EmptyView(), tag: "7")),
            SpanPreference(item: GridItem(EmptyView(), tag: "8")),
            SpanPreference(item: GridItem(EmptyView(), tag: "9"))
        ]
        let arrangement = resolver.arrange(preferences: items, columnsCount: 4)
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
