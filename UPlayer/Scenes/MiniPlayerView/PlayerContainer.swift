//
//  PlayerContainer.swift
//  UPlayer
//
//  Created by abuzeid on 25.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class PlayerContainerController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 1
        self.view.addSubview(stack)
        stack.setConstrainsEqualToSafeArea()
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor
        addPopulerTracksController()
        addMiniPlayer()
    }
}

private extension PlayerContainerController {
    func addPopulerTracksController() {
        let navigationController = UINavigationController(rootViewController: PopulerTracksController())
        AppNavigator.shared.setRootNavigation(root: navigationController)
        addChild(navigationController)
        stack.addArrangedSubview(navigationController.view)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
    }

    func addMiniPlayer() {
        addChild(PlayerView.shared)
        stack.addArrangedSubview(PlayerView.shared.view)
    }
}
