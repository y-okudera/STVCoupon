//
//  AppDelegate.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        firstView(viewController: CouponListRouter.assembleModules(), includeNavigationController: true)
        return true
    }
}

extension AppDelegate {
    
    /// アプリ起動後、最初に表示する画面を設定する
    ///
    /// - Parameters:
    ///   - viewController: 最初に表示する画面のViewController
    ///   - includeNavigationController: NavigationControllerを含めるかどうか
    func firstView(viewController: UIViewController, includeNavigationController: Bool = false) {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if includeNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            // 背景色
            navigationController.navigationBar.barTintColor = .white
            // タイトルテキストの色
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appTheme]
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = viewController
        }
        window?.makeKeyAndVisible()
    }
}
