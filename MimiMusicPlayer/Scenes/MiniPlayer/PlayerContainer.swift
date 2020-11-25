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

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()

    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        self.view.addSubview(stack)
        stack.setConstrainsEqualToParentEdges(useSafeArea:true)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addArtistsController()
        addMiniPlayer()
    }
}

private extension MainViewController {
    func addArtistsController() {
        let navigationController = UINavigationController(rootViewController: ArtistsListController())
        addChild(navigationController)
        stack.addArrangedSubview(navigationController.view)
        navigationController.navigationBar.isTranslucent = false
    }

    func addMiniPlayer() {
        let miniPlayer = MiniPlayerViewController()
        addChild(miniPlayer)
        stack.addArrangedSubview(miniPlayer.view)
        miniPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
}
