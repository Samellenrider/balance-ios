//
//  TabBarController.swift
//  Balance
//
//  Created by Richard Burton on 3/9/19.
//  Copyright © 2019 Balance. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private enum TabIndex: Int {
        case watchlist = 0
        case balance   = 1
        case settings  = 2
    }
    
    let walletsViewController = WalletsViewController()
    let balanceViewController = BalanceViewController()
    let settingsViewController = SettingsViewController()
    
    private var welcomeViewController: WelcomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let walletsNavigationController = UINavigationController(rootViewController: walletsViewController)
        walletsNavigationController.tabBarItem = UITabBarItem(title: "Wallets",
                                                              image: UIImage(named: "walletsTabBarItemImage"),
                                                              selectedImage: UIImage(named: "walletsTabBarItemImageSelected"))
        
        let balanceNavigationController = UINavigationController(rootViewController: balanceViewController)
        balanceNavigationController.tabBarItem = UITabBarItem(title: "Balance",
                                                              image: UIImage(named: "balanceTabBarItemImage"),
                                                              selectedImage: UIImage(named: "balanceTabBarItemImageSelected"))
        
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings",
                                                               image: UIImage(named: "settingsTabBarItemImage"),
                                                               selectedImage: UIImage(named: "settingsTabBarItemImageSelected"))

        viewControllers = [walletsNavigationController, balanceNavigationController, settingsNavigationController]
        selectedIndex = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletAdded), name: CoreDataHelper.Notifications.ethereumWalletAdded, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CoreDataHelper.ethereumWalletCount() == 0 && welcomeViewController == nil {
            welcomeViewController = WelcomeViewController()
            present(welcomeViewController!, animated: false, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // NOTE: Don't call super here or it will crash
        if tabBar.items?.firstIndex(of: item) == TabIndex.balance.rawValue {
            balanceViewController.loadData()
        }
    }
    
    @objc private func walletAdded() {
        if welcomeViewController != nil {
            dismiss(animated: true)
            welcomeViewController = nil
        }
    }
}
