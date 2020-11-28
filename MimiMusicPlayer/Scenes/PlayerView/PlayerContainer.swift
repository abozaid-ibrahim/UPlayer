//
//  PlayerContainer.swift
//  MimiMusicPlayer
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
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 1
        self.view.addSubview(stack)
        stack.setConstrainsEqualToParentEdges(useSafeArea: true)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor
        addArtistsController()
        addMiniPlayer()
    }
}

private extension PlayerContainerController {
    func addArtistsController() {
        let navigationController = UINavigationController(rootViewController: ArtistsListController())
        addChild(navigationController)
        stack.addArrangedSubview(navigationController.view)
        navigationController.navigationBar.isTranslucent = false
    }

    func addMiniPlayer() {
        addChild(PlayerView.shared)
        stack.addArrangedSubview(PlayerView.shared.view)
    }
}
