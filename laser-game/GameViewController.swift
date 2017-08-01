//
//  GameViewController.swift
//  Laser-Game
//
//  Created by Thomas Propson on 9/24/16.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
//
//
/*TODO:
 - !! add title layer that displays widget name above middle widget
 - !! add tap gesture recognizers to transition widgets from scrollview to gamescene.
 - ! clean up the code
    - make loadGameScene intake a GameScene parameter (functionality moreso than best practice)
    - determine which properites should be let constants and which need to be vars (best pract.)
    - use markers (best pract.)
 */

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    //MARK: - Properties
    
    //The ScrollView that will house the widgets on the HUD
    var scrollView: CentroidalScrollView!
    var widgetsInScrollview: [Widget]!
    
    //MARK: - Loading the SKScene
    
    //SHOULD Load any SKScene by intaking said scene as a parameter
    func loadGameScene(){
        let scene = GameScene(size: self.view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    //MARK: - Populating the HUD
    
    func addHUD(){
        //Middle Marker
        let middleMarker = CAShapeLayer()
        middleMarker.fillColor = UIColor.red.cgColor
        middleMarker.path = UIBezierPath(ovalIn: CGRect(x: UIScreen.main.bounds.midX-5, y: UIScreen.main.bounds.midY-5, width: 10, height: 10)).cgPath
        self.view.layer.addSublayer(middleMarker)
        
        //ScrollView Buttons
        let rightButton = UIButton(type: .roundedRect)
        rightButton.frame = CGRect(x:459,y:270,width:50,height:50)
        rightButton.layer.cornerRadius = 25
        rightButton.addTarget(self, action: #selector(scrollCSVRight), for: .touchUpInside)
        rightButton.backgroundColor = UIColor.red
        self.view.addSubview(rightButton)
        
        let leftButton = UIButton(type: .roundedRect)
        leftButton.frame = CGRect(x:59,y:270,width:50,height:50)
        leftButton.layer.cornerRadius = 25
        leftButton.backgroundColor = UIColor.red
        leftButton.addTarget(self, action: #selector(scrollCSVLeft), for: .touchUpInside)
        self.view.addSubview(leftButton)
        
        //ScrollView
        //parameters to be passed into scrollview constructor
        let distFromBottom = CGFloat(20)
        let subsVisible = 5
        let smallSize = CGSize(width: 50, height: 50)
        let largeSize = CGSize(width: 65, height: 65)
        let spacing = CGFloat(10)
        
        //prepare images for the scrollview
        let myImages = [UIImage(named: "devwidget1"), UIImage(named: "devwidget1"), UIImage(named: "devwidget1"), UIImage(named: "devwidget1"), UIImage(named: "devwidget1"), UIImage(named: "devwidget1"), UIImage(named: "devwidget1")]
        
        //instantiate the scrollview
        self.scrollView = CentroidalScrollView(superView: self.view, distanceFromBottomOfView: distFromBottom, visibleSubviews: subsVisible, peripheralViewSize: smallSize, middleViewSize: largeSize, subviewSpacing: spacing, imagesForSubviews: myImages as! [UIImage])
        scrollView?.middleViewAlpha = 1.0
        scrollView?.peripheralViewAlpha = 0.8
        self.view.addSubview(self.scrollView!)
    }
    
    //MARK: - HUD Methods
    
    func scrollCSVRight(){
        scrollView.scrollRight()
    }
    
    func scrollCSVLeft(){
        scrollView.scrollLeft()
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

