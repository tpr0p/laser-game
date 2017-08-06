//
//  GameViewController.swift
//  Laser-Game
//
//  Created by Thomas Propson on 9/24/16.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
//
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate, SKSceneDelegate {
    
    //MARK: - Properties

    var scene: GameScene!
    var scrollView: CentroidalScrollView!
    var widgetsInScrollview: [Widget]!
    var middleWidgetRecognizer: UILongPressGestureRecognizer!
    var movableWidget: UIImageView!
    
    //MARK: - Loading the SKScene
    
    //SHOULD Load any SKScene by intaking said scene as a parameter
    func loadGameScene(){
        scene = GameScene(size: self.view.bounds.size)
        scene.viewController = self
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    //MARK: - Populating the HUD
    
    func addHUD(){
        //MARK: - Middle Marker
        let middleMarker = CAShapeLayer()
        middleMarker.fillColor = UIColor.red.cgColor
        middleMarker.path = UIBezierPath(ovalIn: CGRect(x: UIScreen.main.bounds.midX-5, y: UIScreen.main.bounds.midY-5, width: 10, height: 10)).cgPath
        self.view.layer.addSublayer(middleMarker)
        
        //MARK: - ScrollView
        //parameters to be passed into scrollview constructor
        let distFromBottom = CGFloat(20)
        let subsVisible = 5
        let smallSize = CGSize(width: 50, height: 50)
        let largeSize = CGSize(width: 65, height: 65)
        let spacing = CGFloat(10)
        
        //get images and names for the scrollview
        widgetsInScrollview = [Widget(name: "devwidget1"), Widget(name: "devwidget2"), Widget(name: "devwidget3"), Widget(name: "devwidget1"), Widget(name: "devwidget2"), Widget(name: "devwidget3"), Widget(name: "devwidget1"), ]
        var imagesForSubviews = [UIImage]()
        for widget in widgetsInScrollview{
            imagesForSubviews.append(widget.image)
        }
        var namesForSubviews = [String]()
        for widget in widgetsInScrollview{
            namesForSubviews.append(widget.name)
        }
        //instantiate scrollView and assign properties
        self.scrollView = CentroidalScrollView(superView: self.view, distanceFromBottomOfView: distFromBottom, subviewsVisible: subsVisible, peripheralViewSize: smallSize, middleViewSize: largeSize, subviewSpacing: spacing, subviewImages: imagesForSubviews)
        scrollView?.middleViewAlpha = 1.0
        scrollView?.peripheralViewAlpha = 0.8
        scrollView?.subviewNames = namesForSubviews
        scrollView?.subviewNameDisplayEnabled = true
        self.view.addSubview(self.scrollView!)
        
        //MARK: - ScrollView Appendages
        let rightButton = UIButton(type: .roundedRect)
        rightButton.frame = CGRect(x:459,y:270,width:50,height:50)
        rightButton.layer.cornerRadius = 25
        rightButton.addTarget(self, action: #selector(scrollRight), for: .touchUpInside)
        rightButton.backgroundColor = UIColor.red
        self.view.addSubview(rightButton)
        
        let leftButton = UIButton(type: .roundedRect)
        leftButton.frame = CGRect(x:59,y:270,width:50,height:50)
        leftButton.layer.cornerRadius = 25
        leftButton.backgroundColor = UIColor.red
        leftButton.addTarget(self, action: #selector(scrollLeft), for: .touchUpInside)
        self.view.addSubview(leftButton)
        
        //MARK: - Middle Widget Tap Recognizer
        middleWidgetRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleMiddleWidgetSelected))
        middleWidgetRecognizer.delegate = self
        middleWidgetRecognizer.minimumPressDuration = 0
        self.scrollView.addGestureRecognizer(middleWidgetRecognizer)
    }
    
    //MARK: - HUD Methods
    
    func scrollRight(){
        scrollView.scrollRight()
    }
    
    func scrollLeft(){
        scrollView.scrollLeft()
    }
    
    func handleMiddleWidgetSelected(_ sender: UIGestureRecognizer){
        //When the user drags the movableWidget and there is a movableWidget (this is the mode occurence in this if-series so it is evaluated first)
        if (middleWidgetRecognizer.state == .changed && movableWidget != nil){
            //the center of movableWidget will be updated to the location of the latest drag point
            movableWidget.center = (sender.location(in: self.view))
        }
        //When the user taps on the scrollView's current middle widget, there is no current movableWidget, and it is the beginning of the middleWidgetRecognizer cycle
        else if ((scrollView.currentMiddleView?.frame.contains(sender.location(in: scrollView)))! && movableWidget == nil && middleWidgetRecognizer.state == .began){
            //adds a movableWidget imageview that has the same properties as the scrollview's current middle widget and centers the movableWidget where the user tapped down
            //!Show Scene Grid
            movableWidget = UIImageView(image: UIImage(named: scrollView.subviewNames[scrollView.currentMiddleViewIndex]))
            movableWidget.frame = CGRect(x: 0, y: 0, width: (scrollView.currentMiddleView?.frame.width)!, height: (scrollView.currentMiddleView?.frame.height)!)
            movableWidget.center = (sender.location(in: self.view))
            self.view.addSubview(movableWidget)
        }
        //When the user releases the touch on the movable widget and there is a movableWidget
        else if (middleWidgetRecognizer.state == .ended && movableWidget != nil) {
            //the movableWidget will be added to the skscene(if possible) and then removed from the uiview
            scene.addWidget(movableWidget.image!, at: sender.location(in: self.view))
            //!remove scene grid
            movableWidget.removeFromSuperview()
            movableWidget = nil
        }
        //When the gesture recognizer gets an unkown input or is cancelled and there is a movableWidget
        else if ((middleWidgetRecognizer.state == .cancelled || middleWidgetRecognizer.state == .failed) && movableWidget != nil){
            //the movableWidget is removed from the uiview
            //!remove scene grid
            movableWidget.removeFromSuperview()
            movableWidget = nil
        }
    }
    
    //MARK: - VC Lifecycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        loadGameScene()
        addHUD()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

