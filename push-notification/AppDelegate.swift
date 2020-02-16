//
//  AppDelegate.swift
//  push-notification
//
//  Created by Atsuki Kakehi on 2020/02/09.
//  Copyright © 2020 Atsuki Kakehi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            
            if settings.alertSetting == .enabled {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // 1. Convert device token to string
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         // 2. Print device token to use for PNs payloads
         print("debug0000 : Device Token: \(token)")
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("debug0000 : Failed to register for remote notifications with error: \(error)")
     }
    
    
    // Push通知受信時とPush通知をタッチして起動したときに呼ばれる
    // これが動いていない
    func application(
        application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("debug0000 : didReceiveRemoteNotification")
        switch application.applicationState {
        case .inactive:
            // アプリがバックグラウンドにいる状態で、Push通知から起動したとき
            print("debug0000 : inactive")
            break
        case .active:
            // アプリ起動時にPush通知を受信したとき
            print("debug0000 : active")
            break
        case .background:
            // アプリがバックグラウンドにいる状態でPush通知を受信したとき
            print("debug0000 : background")
            break
        }
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // アプリが foreground の時に通知を受け取った時に呼ばれるメソッド
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        print("debug0000 : userNotificationCenter")
        if notification.request.trigger is UNPushNotificationTrigger {
            print("debug0000 : This is UNPushNotificationTrigger")
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("debug0000 : userNotificationCenter didReceive")
    }

}
