//
//  LoadViewController.swift
//  Weather
//
//  Created by Nikita Velichko on 4.07.23.
//

import UIKit

class LoadViewController: UIViewController {

    @IBOutlet weak var firstPoint: UILabel!
    @IBOutlet weak var secondPoint: UILabel!
    @IBOutlet weak var thirdPoint: UILabel!
    @IBOutlet weak var pointsStackView: UIStackView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
      Bundle.main.loadNibNamed("LoadViewController", owner: self, options: nil)
        messageLabel.isHidden = true
        restartButton.isHidden = true
        animatePointsLoad()
    }
    
    func showError(types: messageType) {
        switch types {
        case .locationError:
            pointsStackView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "Location Error: Go to settings and turn on location recognition."
            restartButton.isHidden = false
        case .networkError:
            pointsStackView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "Internet Error: Something went wrong with internet connection, please try again later."
            restartButton.isHidden = false
        }
    }
    
    private func animatePointsLoad() {
      
      firstPoint.transform = CGAffineTransform(translationX: 1, y: 3)
      secondPoint.transform = CGAffineTransform(translationX: 1, y: 3)
      thirdPoint.transform = CGAffineTransform(translationX: 1, y: 3)
      
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     options: [.autoreverse, .repeat],
                     animations: {
                      self.firstPoint.transform = .identity
                      self.firstPoint.alpha = 0.2
                     },
                     completion: nil)
      
      UIView.animate(withDuration: 0.5,
                     delay: 0.5,
                     options: [.autoreverse, .repeat],
                     animations: {
                      self.secondPoint.transform = .identity
                      self.secondPoint.alpha = 0.2
                     },
                     completion: nil)
      
      UIView.animate(withDuration: 0.5,
                     delay: 1,
                     options: [.autoreverse, .repeat],
                     animations: {
                      
                      self.thirdPoint.transform = .identity
                      self.thirdPoint.alpha = 0.2
                     },
                     completion: nil)
    }
    
    private func pathAnimation() {
      
      let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
      pathAnimationEnd.fromValue = 0
      pathAnimationEnd.toValue = 1
      pathAnimationEnd.duration = 2
      pathAnimationEnd.fillMode = .both
      pathAnimationEnd.isRemovedOnCompletion = false
      
      let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
      pathAnimationStart.fromValue = 0
      pathAnimationStart.toValue = 1
      pathAnimationStart.duration = 2
      pathAnimationStart.fillMode = .both
      pathAnimationStart.isRemovedOnCompletion = false
      pathAnimationStart.beginTime = 1
      
      let animationGroup = CAAnimationGroup()
      animationGroup.duration = 3
      animationGroup.fillMode = CAMediaTimingFillMode.backwards
      animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
      animationGroup.repeatCount = .infinity
    }

    @IBAction func restartAction(_ sender: Any) {
        messageLabel.isHidden = true
        restartButton.isHidden = true
        pointsStackView.isHidden = false
        NotificationCenter.default.post(name: Notification.Name("UpdateWeather"), object: nil)
    }
}

enum messageType {
    case locationError
    case networkError
}
