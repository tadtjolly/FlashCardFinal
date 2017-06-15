//
//  AppDelegate.swift
//  Flashcard Touch
//
//  Created by CPU11713 on 4/28/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

var UID = " " 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        Locale.setupInitialLanguage()
        setupNotifications()

//        // Google Analystic
//        guard let gai = GAI.sharedInstance() else {
//            assert(false, "Google Analytics not configured correctly")
//        }
//        gai.tracker(withTrackingId: "UA-100062579-1")
//        // Optional: automatically report uncaught exceptions.
//        gai.trackUncaughtExceptions = true
//        
//        // Optional: set Logger to VERBOSE for debug information.
//        // Remove before app release.
//        gai.logger.logLevel = .verbose;
        
        return true
    }
    fileprivate func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: OperationQueue.main) {
            [weak self] notification in
            guard let `self` = self else { return }
            
            //	this is the only way I know of to force-reload storyboard-based stuff
            //	limitations like this is one of the main reason why I avoid basing entire app on them
            //	since doing this essentialy resets the app and all user-generated context and data
            
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = sb.instantiateInitialViewController()
//            self.window?.rootViewController = vc
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //                let viewController = sb.instantiateViewController(withIdentifier: "tabBarController")
            let viewController = sb.instantiateInitialViewController() as! UITabBarController
            let navivc = viewController.viewControllers![0] as! UINavigationController
            let deckvc = navivc.viewControllers[0] as! DeckViewController
            deckvc.UID = UID
            //            print(uidLogin)
            //                viewController.UID = self.uidLogin
            
            //                viewController.mangDictCount = self.mangDictCount
            //                viewController.decks = self.decks
            //                print("-------------\(viewController.decks)")
            //                viewController.decksversion2 = self.decksversion2
            
            //self.present(viewController, animated: true, completion: nil)
            self.window?.rootViewController = viewController


        }
    }

    //gọi hàm application open URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    //khi không goi dc trong application
//    override init(){
//        super.init()
//        FIRApp.configure()
//    }
    
    // MARK: *** Google Analystic UA-100062579-1

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



