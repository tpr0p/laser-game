//
//  StartScreenController.swift
//  laser-game
//
//  Created by Thomas Propson on 7/18/17.
//  Copyright © 2017 com.thomaspropson. All rights reserved.
//

import UIKit

class StartScreenController: UIViewController {
    
    func getStats() {
        debugPrint("Width of Screen: \(UIScreen.main.bounds.width)")
        debugPrint("Height of Screen: \(UIScreen.main.bounds.height)")
    }
    
    func assignBackground(){
        let background = UIImage(named: "startscreen")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func instantiateButtons(){
        let playButton = UIButton(type: UIButtonType.roundedRect)
        playButton.frame = CGRect(x: (209), y: (30), width: (150), height: (70))
        playButton.layer.cornerRadius = 15
        playButton.setBackgroundImage(UIImage(named: "playbutton"), for: .normal)
        playButton.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(playButton)
        self.view.bringSubview(toFront: playButton)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        let settingsButton = UIButton(type: UIButtonType.roundedRect)
        settingsButton.frame = CGRect(x: (209), y: (130), width: (150), height: (70))
        settingsButton.layer.cornerRadius = 15
        settingsButton.setBackgroundImage(UIImage(named: "settingsbutton"), for: .normal)
        settingsButton.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(settingsButton)
        self.view.bringSubview(toFront: settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        // Gear Button is alternative to settingsButton
        /*
         let gearButton = UIButton(type: UIButtonType.roundedRect)
         gearButton.frame = CGRect(x: 518*seW,y: 110*seH,width: 50*seW,height: 30*seH)
         gearButton.setBackgroundImage(UIImage(named: "gearbutton"), for: .normal)
         gearButton.contentMode = UIViewContentMode.scaleToFill
         self.view.addSubview(gearButton)
         self.view.bringSubview(toFront: gearButton)
         gearButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
         */
        
        let infoButton = UIButton(type: UIButtonType.roundedRect)
        infoButton.frame = CGRect(x: 490,y: 270,width: 70,height: 40)
        infoButton.setBackgroundImage(UIImage(named: "infobutton"), for: .normal)
        infoButton.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(infoButton)
        self.view.bringSubview(toFront: infoButton)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    func playButtonTapped() {
        debugPrint("Play Button Tapped")
        
        //Present GameViewController
        let gvc = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.present(gvc, animated:true, completion:nil)
    }
    
    func settingsButtonTapped(){
        debugPrint("Settings Button Tapped")
    }
    
    func infoButtonTapped(){
        debugPrint ("Info Button Tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStats()
        assignBackground()
        instantiateButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
