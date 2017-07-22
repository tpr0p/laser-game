//
//  GameViewController.swift
//  Laser-Game
//
//  Created by Thomas Propson on 9/24/16.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
// Background must be set in game scene
//
/*TODO:
 - add tap gesture recognizers to transition widgets from scrollview to gamescene.
 */

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    //widget and widget properties
    var currentMiddleWidget: UIImageView? = nil
    var nextMiddleWidget: UIImageView? = nil
    
    
    var regularWidgetSize: CGSize = CGSize(width: 50, height: 50)
    let middleWidgetSize: CGSize = CGSize(width: 65, height: 65)
    let widgetSpacing: CGFloat = 10
    
    let regularWidgetAlpha: CGFloat = 0.65
    let middleWidgetAlpha: CGFloat = 1.0
    
    //content
    struct widget{
        var image: UIImage
        var title: String
    }
    var myWidgets = [widget]()
    
    //scrollView Properties
    //widgetsInView must be odd
    let widgetsInView: Int = 5
    var contentOffsetMin: CGFloat = 0
    var contentOffsetMax: CGFloat = 0
    var initialContentOffsetX: CGFloat = 0.0
    
    var isMovingRight: Bool = false
    var isMovingLeft: Bool = false
    
    //animations
    let scrollAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut)
    
    var titleLayer: CATextLayer? = nil
    let ephemeralTitleAnimation = CABasicAnimation()
    
    func addScrollAnimationCompletion(){
        scrollAnimation.addCompletion{_ in
            self.isMovingLeft = false
            self.isMovingRight = false
            
            self.titleLayer?.removeAllAnimations()
            self.titleLayer?.removeFromSuperlayer()
            self.titleLayer = CATextLayer()
            self.titleLayer?.frame = CGRect(x: UIScreen.main.bounds.midX-10,y:self.scrollView.frame.minY-20, width: 20, height: 5)
            
            self.setCurrentMiddleWidget()
            
            var i: Int = 0
            for x in self.myWidgets{
                if(x.image == self.currentMiddleWidget?.image){
                    self.titleLayer?.string = self.myWidgets[i].title
                }
                i += 1
            }
            
            self.view.layer.addSublayer(self.titleLayer!)
            self.titleLayer?.add(self.ephemeralTitleAnimation, forKey: "opacity")
        }
    }
    
    func setCurrentMiddleWidget(){
        for subview in self.scrollView.subviews{
            let frame = scrollView.convert(subview.frame, to: view)
            if frame.contains(CGPoint(x: UIScreen.main.bounds.midX, y: 250)){
                currentMiddleWidget = subview as? UIImageView
            }
        }
    }
    
    func enlargeWidget(widget: UIImageView?, size: CGSize){
        let deltaW = size.width - (widget?.frame.width)!
        let deltaH = size.height - (widget?.frame.height)!
        let width = (widget?.frame.width)! + deltaW
        let height = (widget?.frame.height)! + deltaH
        
        if(self.isMovingRight){
            //enlarges & pushes to maintain widgetspacing
            widget?.frame = CGRect(x: (widget?.frame.minX)!-deltaW, y: (scrollView.frame.height-height)/2, width: width, height: height)
        }
        else{
            //enlarges only
            widget?.frame = CGRect(x: (widget?.frame.minX)!, y: (scrollView.frame.height-height)/2, width: width, height: height)
        }
    }
    
    
    func shrinkWidget(widget: UIImageView?, size: CGSize){
        let deltaW = (widget?.frame.width)! - size.width
        let deltaH = (widget?.frame.height)! - size.height
        let width = (widget?.frame.width)! - deltaW
        let height = (widget?.frame.height)! - deltaH
        
        if(self.isMovingLeft){
            //shrinks & pushes to maintain widgetspacing
            widget?.frame = CGRect(x: (widget?.frame.minX)!+deltaW, y: (scrollView.frame.height-height)/2, width: width, height: height)
        }
        else{
            //shrinks only
            widget?.frame = CGRect(x: (widget?.frame.minX)!, y: (scrollView.frame.height-height)/2, width: width, height: height)
        }
    }
    
    func rightButtonTapped(){
        if (!scrollAnimation.isRunning && (scrollView.contentOffset.x < contentOffsetMax)){
            //set directional bool
            self.isMovingRight = true
            
            //set currentMiddleWidget
            setCurrentMiddleWidget()
            
            //set nextMiddleWidget
            var index: Int = 0
            while(index < scrollView.subviews.count){
                let frame = scrollView.convert(scrollView.subviews[index].frame, to: view)
                if(frame.contains(CGPoint(x: UIScreen.main.bounds.midX, y: 250))){
                    nextMiddleWidget = scrollView.subviews[index+1] as? UIImageView
                }
                index += 1
            }
            
            //animations
            scrollAnimation.addAnimations {
                //scroll the scrollview
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.regularWidgetSize.width + self.widgetSpacing, y: self.scrollView.contentOffset.y), animated: false)
                
                //animate widgets
                self.shrinkWidget(widget: self.currentMiddleWidget, size: self.regularWidgetSize)
                self.currentMiddleWidget?.alpha = self.regularWidgetAlpha
                self.enlargeWidget(widget: self.nextMiddleWidget, size: self.middleWidgetSize)
                self.nextMiddleWidget?.alpha = self.middleWidgetAlpha
            }
            addScrollAnimationCompletion()
            scrollAnimation.startAnimation()
        }
    }
    
    func leftButtonTapped(){
        if(!scrollAnimation.isRunning && (scrollView.contentOffset.x > contentOffsetMin)){
            //set directional bool
            self.isMovingLeft = true
            
            //set CurrentMiddleWidget
            setCurrentMiddleWidget()
            
            //set NextMiddleWidget
            var index: Int = 0
            while(index < scrollView.subviews.count){
                let frame = scrollView.convert(scrollView.subviews[index].frame, to: view)
                if(frame.contains(CGPoint(x: UIScreen.main.bounds.midX, y: 250))){
                    nextMiddleWidget = scrollView.subviews[index-1] as? UIImageView
                }
                index += 1
            }
            
            //animations
            scrollAnimation.addAnimations {
                //scroll the scrollview
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - (self.regularWidgetSize.width + self.widgetSpacing), y: self.scrollView.contentOffset.y), animated: false)
                
                //animate widgets
                self.shrinkWidget(widget: self.currentMiddleWidget, size: self.regularWidgetSize)
                self.currentMiddleWidget?.alpha = self.regularWidgetAlpha
                self.enlargeWidget(widget: self.nextMiddleWidget, size: self.middleWidgetSize)
                self.nextMiddleWidget?.alpha = self.middleWidgetAlpha
            }
            addScrollAnimationCompletion()
            scrollAnimation.startAnimation()
        }
    }
    
    override func viewDidLoad() {
        //load the gamescene
        let scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        //set up the background and buttons of the view
        let middleMarker = CAShapeLayer()
        middleMarker.fillColor = UIColor.red.cgColor
        middleMarker.path = UIBezierPath(ovalIn: CGRect(x: UIScreen.main.bounds.midX-5, y: UIScreen.main.bounds.midY-5, width: 10, height: 10)).cgPath
        self.view.layer.addSublayer(middleMarker)
        
        let rightButton = UIButton(type: .roundedRect)
        rightButton.frame = CGRect(x:459,y:270,width:50,height:50)
        rightButton.layer.cornerRadius = 25
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rightButton.backgroundColor = UIColor.red
        self.view.addSubview(rightButton)
        
        let leftButton = UIButton(type: .roundedRect)
        leftButton.frame = CGRect(x:59,y:270,width:50,height:50)
        leftButton.layer.cornerRadius = 25
        leftButton.backgroundColor = UIColor.red
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        self.view.addSubview(leftButton)
        
        //setup ephemeral title animation
        ephemeralTitleAnimation.fromValue = 1
        ephemeralTitleAnimation.toValue = 0
        ephemeralTitleAnimation.isRemovedOnCompletion = true
        ephemeralTitleAnimation.duration = 0.5
        
        //instantiate and initialize the scrollview
        scrollView = UIScrollView()
        let scrollViewWidth = (CGFloat)(self.widgetsInView-1)*(self.regularWidgetSize.width+self.widgetSpacing)+self.middleWidgetSize.width
        let scrollViewX = (UIScreen.main.bounds.width-scrollViewWidth)/2
        scrollView.frame = CGRect(x:scrollViewX,y:(CGFloat)(220),width:scrollViewWidth,height: middleWidgetSize.height)
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        scrollView.isScrollEnabled = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        //declare scrollview widget content
        myWidgets.append(widget(image: UIImage(named: "devwidget1")!,title: "Cat"))
        myWidgets.append(widget(image: UIImage(named: "devwidget2")!,title: "Dog"))
        myWidgets.append(widget(image: UIImage(named: "devwidget3")!,title: "Turtle"))
        myWidgets.append(widget(image: UIImage(named: "devwidget1")!,title: "Cat"))
        myWidgets.append(widget(image: UIImage(named: "devwidget2")!,title: "Dog"))
        myWidgets.append(widget(image: UIImage(named: "devwidget3")!,title: "Turtle"))
        
        //add images to the scrollview
        var i: Int = 0
        var xPos: CGFloat
        for thisWidget in myWidgets{
            let imageView = UIImageView()
            imageView.image = thisWidget.image
            if(i == 0){
                xPos = 0
            }
            else{
                xPos = middleWidgetSize.width + (CGFloat)(i) * widgetSpacing + CGFloat(i-1) * regularWidgetSize.width
            }
            //the x and y coordinates of each imageView frame are relative to the top left origin of the scrollview
            imageView.frame = CGRect(x: xPos, y: (scrollView.frame.height-regularWidgetSize.height)/2, width: regularWidgetSize.width
                , height: regularWidgetSize.height)
            scrollView.addSubview(imageView)
            i += 1
        }
        
        //set scrollView initial view
        initialContentOffsetX = -(scrollViewWidth/2 - middleWidgetSize.width/2)
        scrollView.contentOffset = CGPoint(x:initialContentOffsetX, y:0)
        //make widgets lighter
        for subview in scrollView.subviews{
            subview.alpha = regularWidgetAlpha
        }
        //update middle widget
        setCurrentMiddleWidget()
        enlargeWidget(widget: currentMiddleWidget, size: self.middleWidgetSize)
        currentMiddleWidget?.alpha = middleWidgetAlpha
        
        //set scrollview properties based upon how the scroll view was initialized
        contentOffsetMin = initialContentOffsetX
        contentOffsetMax = (CGFloat)(scrollView.subviews.count-((widgetsInView-1)/2+1))*(regularWidgetSize.width+widgetSpacing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

