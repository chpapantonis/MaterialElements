//
//  MaterialLoadingSpinner.swift
//  MaterialLoadingSpinner
//
//  Created by Christos Papantonis on 03/03/2019.
//  Copyright © 2019 Christos Papantonis. All rights reserved.
//

import UIKit

class MaterialLoadingSpinner: UIView {

    public let circleLayer = CAShapeLayer()
    private(set) var isAnimating = false
    var animationDuration : TimeInterval = 2.0
    var size: CGFloat = 50
    var strokeColor: UIColor = UIColor.black
    var strokeWidth: CGFloat = 1.5
    
    // MARK : initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        layerInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layerInit()
    }
    
    
    /// Main initializer. Gets a frame and animates the spinner in that frame. If you need view to be on the whole screen
    /// just pass as a frame in the initializer the self.view.frame and will cover the whole screen.
    /// - Parameters:
    ///   - view: the view from which we call the spinner
    ///   - size: the size of the spinner
    ///   - backgroundColor: the background color of the View of the spinner
    ///   - strokeColor: the color of the spinner
    ///   - strokeWidth: the width of the spinner
    public init (frame: CGRect, size: CGFloat = 50,
                 backgroundColor: UIColor = UIColor.clear,
                 strokeColor: UIColor = UIColor.black,
                 strokeWidth :CGFloat = 1.5) {
        super.init(frame: frame)
        self.size = size
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.backgroundColor = backgroundColor
        layerInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if self.circleLayer.frame != self.bounds {
            updateCircle()
        }
    }
    
    // MARK : layer init
    open func layerInit() {
        self.layer.addSublayer(circleLayer)
        
        // Dummy init. Will be overriden from the user later
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.strokeEnd = 1
        circleLayer.strokeStart = 0
        circleLayer.fillColor = nil
        
        circleLayer.lineWidth = strokeWidth
        circleLayer.lineCap = CAShapeLayerLineCap.round
    }
    
    
    
    private func updateCircle() {
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        let radius = (self.size - self.circleLayer.lineWidth) / 2.0
        let startingAngle : CGFloat = 0.0
        let endingAngle : CGFloat = 2.0 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: center, radius: radius,
                                startAngle: startingAngle, endAngle: endingAngle, clockwise: true)
        
        self.circleLayer.path = path.cgPath
        self.circleLayer.frame = self.bounds
    }
    
    func start() {
        
        if(self.isAnimating){
            return
        }
        
        self.isAnimating = true
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotateAnimation.values = [ 0.0,Float.pi,(2.0 * Float.pi) ] // force it to be clock wise
        rotateAnimation.duration = self.animationDuration
        
        //Start is responsible for the erasing part of the circle
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = (self.animationDuration/2 )
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        
        //Responsible for the drawing part of the circle
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = (self.animationDuration/2)
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        
        //Then
        //Show the whole circle as is
        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = (self.animationDuration / 2.0)
        endTailAnimation.duration = (self.animationDuration / 2.0)
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1

        //Animate the erasing part
        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.beginTime = (self.animationDuration / 2.0)
        endHeadAnimation.duration = (self.animationDuration / 2.0)
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1


        
        let animations = CAAnimationGroup()
        animations.duration = self.animationDuration
        animations.animations = [
            rotateAnimation,
            headAnimation,
            tailAnimation,
            endHeadAnimation,
            endTailAnimation
        ]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false
        
        self.circleLayer.add(animations, forKey: "animations")
    }
    
    open func stop() {
        self.isAnimating = false
        self.circleLayer.removeAnimation(forKey: "animations")
    }
    



}
