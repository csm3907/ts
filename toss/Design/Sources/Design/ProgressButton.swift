//
//  ProgressButton.swift
//  tosshomeworkSample
//
//  Created by 정준영 on 23/05/2019.
//  Copyright © 2019 Viva Republica. All rights reserved.
//

import UIKit

public class ProgressButton: UIButton {
    
    var completion: (() -> Void)?
    
    private let radius: CGFloat
    private let duration: CGFloat
    private let image: UIImage?
    private let color: UIColor
    public init(image: UIImage? = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate),
         color: UIColor = UIColor.blue,
         radius: CGFloat = 16.0,
         duration: CGFloat = 2.0,
         completion: (() -> Void)? = nil) {
        self.radius = radius
        self.color = color
        self.duration = duration
        self.image = image
        self.completion = completion
        
        super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        
        backgroundColor = .clear
        tintColor = color
        
        var config = UIButton.Configuration.plain()
        config.image = image
        config.contentInsets = NSDirectionalEdgeInsets(
            top: radius / 2,
            leading: radius / 2,
            bottom: radius / 2,
            trailing: radius / 2
        )
        config.imagePlacement = .all
        config.imagePadding = 0
        configuration = config
        
        imageView?.contentMode = .scaleAspectFit
        setImage(image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var maskLayer = CAShapeLayer()
    
    private lazy var circlePath: UIBezierPath = {
        let arcCenter = CGPoint(x: radius, y: radius)
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius,
                                      startAngle: 3 * .pi / 2, endAngle: -.pi / 2, clockwise: false)
        circlePath.lineWidth = 1
        return circlePath
    }()
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 1
        maskLayer.path = circlePath.cgPath
        
        layer.addSublayer(maskLayer)
    }
    
    public func animate(from progress: CGFloat) {
        cancel()
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 1.0
        layer.path = circlePath.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progress
        animation.toValue = 1.0
        animation.duration = CFTimeInterval(duration * (1 - progress))
        animation.delegate = self
        
        layer.add(animation, forKey: "progressAnimation")
        self.layer.addSublayer(layer)
    }
    
    public func cancel() {
        layer.sublayers?.forEach { layer in
            if layer is CAShapeLayer {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
}

// MARK: - CAAnimationDelegate
extension ProgressButton: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("stop!!!!!!!!!!!!!!!!!!!!!!!")
        guard flag else { return }
        completion?()
    }
}
