//
//  Navigation.swift
//  UPlayer
//
//  Created by abuzeid on 19.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class AppNavigator {
    static let shared = AppNavigator()
    private(set) var navigationController: UINavigationController?
    private init() {}
    func set(window: UIWindow?) {
        let navigationController = UINavigationController(rootViewController: Destination.populerTracks.controller)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func setRootNavigation(root: UINavigationController) {
        navigationController = root
    }

    func push(_ dest: Destination) {
        navigationController?.pushViewController(dest.controller, animated: true)
    }

    @discardableResult
    func presentModally(_ dest: Destination, onComplete: (() -> Void)?) -> UIViewController? {
        let controller = dest.controller
        controller.modalPresentationStyle = .overCurrentContext
        navigationController?.present(controller, animated: true, completion: onComplete)
        return controller
    }
}
