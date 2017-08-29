//import UIKit
//import UserNotifications
//
//import Firebase
//
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        /**************************** Push service start *****************************/
//        // iOS 10 support
////        FirebaseApp.configure()
//        if #available(iOS 10, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//            application.registerForRemoteNotifications()
//        }
////            // iOS 9 support
////        else if #available(iOS 9, *) {
////            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
////            UIApplication.shared.registerForRemoteNotifications()
////        }
////            // iOS 8 support
////        else if #available(iOS 8, *) {
////            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
////            UIApplication.shared.registerForRemoteNotifications()
////        }
////            // iOS 7 support
////        else {
////            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
////        }
//        /***************************** Push service end ******************************/
//        return true
//    }
//
//    // Called when APNs has assigned the device a unique token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // Convert token to string
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//
//        // Print it to console
//        print("APNs device token: \(deviceTokenString)")
//
//        // Persist it in your backend in case it's new
//    }
//
//    // Called when APNs failed to register the device for push notifications
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        // Print the error to console (you should alert the user that registration failed)
//        print("APNs registration failed: \(error)")
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//
//    // Push notification received
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received: \(data)")
//    }
//
//
//}


//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import UserNotifications
import Fabric
import Crashlytics

import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let userDefaults = UserDefaults.standard
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        return true
        
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("1Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    // Application entered in foreground
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
        if self.window?.rootViewController is LetterViewController{
            print("쪽지")
        }
//        application.applicationIconBadgeNumber = 0;
    }
    
    // Application entered in background
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        Messaging.messaging().shouldEstablishDirectChannel = false
        print("Disconnected from FCM.")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("2Message ID: \(messageID)")
//        }
        
        // Print full message.
//        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        userDefaults.set(userDefaults.integer(forKey: "notReadPush")+1, forKey: "notReadPush")
        UIApplication.shared.applicationIconBadgeNumber = userDefaults.integer(forKey: "notReadPush")
        print("didReceiveRemoteNotification 앱 뱃지 \(userDefaults.integer(forKey: "notReadPush"))로 늘어남 ^0^")
        
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
////            print("Message ID: \(messageID)")
//        }
//        
        // Print full message.
//        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, UNNotificationPresentationOptions(rawValue: UInt(userDefaults.integer(forKey: "notReadPush")+1)), .sound])
//        userDefaults.set(userDefaults.integer(forKey: "notReadPush")+1, forKey: "notReadPush")
//        print("userNotificationCenter 앱 뱃지 \(userDefaults.integer(forKey: "notReadPush"))로 늘어남 ^0^")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
////            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
//        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //포그라운드에서 수신됨
//        print("Received data message: \(remoteMessage.appData)")
        
//        userDefaults.set(userDefaults.integer(forKey: "notReadPush")+1, forKey: "notReadPush")
//        UIApplication.shared.applicationIconBadgeNumber = userDefaults.integer(forKey: "notReadPush")
//        print("MESSAGING 앱 뱃지 \(userDefaults.integer(forKey: "notReadPush"))로 늘어남 ^0^")
        
    }
    // [END ios_10_data_message]
}
