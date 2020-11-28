//
//  UIView+Constrains.swift
//  MimiMusicPlayer
//
//  Created by abuzeid on 24.11.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
public extension UIView {
    func setConstrainsEqualToParentEdges(top: Float = 0,
                                         bottom: Float = 0,
                                         leading: Float = 0,
                                         trailing: Float = 0,
                                         useSafeArea: Bool = false) {
        guard let parent = superview else {
            fatalError("This view doesn't have a parent")
        }
        let layoutGuide = useSafeArea ? parent.safeAreaLayoutGuide : parent.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: CGFloat(leading)),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -CGFloat(trailing)),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: CGFloat(top)),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -CGFloat(bottom))])
    }
}
