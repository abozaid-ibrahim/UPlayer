//
//  AppNavigator.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private static var navigator: UINavigationController!

    private init() {}

    func set(window: UIWindow) {
        AppNavigator.navigator = UINavigationController(rootViewController: Destination.artistsList.controller)
        AppNavigator.navigator.setNavigationBarHidden(false, animated: true)
        window.rootViewController = AppNavigator.navigator
        window.makeKeyAndVisible()
    }

    @discardableResult
    func push(_ dest: Destination) -> UIViewController {
        let controller = dest.controller
        AppNavigator.navigator.pushViewController(controller, animated: true)
        return controller
    }
}
