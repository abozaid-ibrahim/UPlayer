//
//  DurationLabel.swift
//
//

import UIKit.UIView

final class DurationLabel: UIView {
    @IBOutlet private var elapsedTimeLabel: UILabel!
    @IBOutlet private var totalTimeLabel: UILabel!
    private let formatter = DurationFromatter()
    func setDuration(for duration: String) {
        totalTimeLabel.text = duration
    }

    func updateTime(with percentage: CGFloat, for duration: Double) {
        let percentage = min(1, max(0, percentage))
        elapsedTimeLabel.text = formatter.display(duration: duration * Double(percentage))
    }

    func animate(scale: Bool) {
        let animationDuration = 0.25
        let scaleFactor: CGFloat = 1.4
        let yTransform: CGFloat = -100.0

        if scale {
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0, usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.2,
                           options: .curveEaseIn, animations: {
                               let yTransform = CGAffineTransform(translationX: 0.0, y: yTransform)
                               let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                               self.transform = yTransform.concatenating(scaleTransform)
                               self.backgroundColor = UIColor.blackColor.withAlphaComponent(0.5)
                           }, completion: nil)
        } else {
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0, usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                               let yTransform = CGAffineTransform(translationX: 0.0, y: 0.0)
                               let scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                               self.transform = yTransform.concatenating(scaleTransform)
                               self.backgroundColor = .blackColor
                           }, completion: nil)
        }
    }
}
