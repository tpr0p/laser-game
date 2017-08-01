//
//  StartScreenController.swift
//  laser-game
//
//  Created by Thomas Propson on 7/18/17.
//  Copyright © 2017 com.thomaspropson. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    //MARK: - Populating the View
    
    func addBackground(){
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode =  .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = UIImage(named: "startscreen")
        backgroundImageView.center = view.center
        view.addSubview(backgroundImageView)
        //Ensures backgroundImageView is behind all other subviews of self.view
        self.view.sendSubview(toBack: backgroundImageView)
    }
    
    func addButtons(){
        let playButton = UIButton(type: .roundedRect)
        playButton.frame = CGRect(x: (209), y: (30), width: (150), height: (70))
        playButton.layer.cornerRadius = 15
        playButton.setBackgroundImage(UIImage(named: "playbutton"), for: .normal)
        playButton.contentMode = .scaleAspectFit
        self.view.addSubview(playButton)
        self.view.bringSubview(toFront: playButton)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        let settingsButton = UIButton(type: .roundedRect)
        settingsButton.frame = CGRect(x: (209), y: (130), width: (150), height: (70))
        settingsButton.layer.cornerRadius = 15
        settingsButton.setBackgroundImage(UIImage(named: "settingsbutton"), for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        self.view.addSubview(settingsButton)
        self.view.bringSubview(toFront: settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        // Gear Button is alternative to settingsButton
        /*
         let gearButton = UIButton(type: .roundedRect)
         gearButton.frame = CGRect(x: 518*seW,y: 110*seH,width: 50*seW,height: 30*seH)
         gearButton.setBackgroundImage(UIImage(named: "gearbutton"), for: .normal)
         gearButton.contentMode = UIViewContentMode.scaleToFill
         self.view.addSubview(gearButton)
         self.view.bringSubview(toFront: gearButton)
         gearButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
         */
        
        let infoButton = UIButton(type: .roundedRect)
        infoButton.frame = CGRect(x: 490,y: 270,width: 70,height: 40)
        infoButton.setBackgroundImage(UIImage(named: "infobutton"), for: .normal)
        infoButton.contentMode = .scaleAspectFit
        self.view.addSubview(infoButton)
        self.view.bringSubview(toFront: infoButton)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Button Actions
    
    func playButtonTapped() {
        debugPrint("Play Button Tapped")
        //Present GameViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gvc = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.present(gvc, animated:true, completion:nil)
    }
    
    func settingsButtonTapped(){
        debugPrint("Settings Button Tapped")
    }
    
    func infoButtonTapped(){
        debugPrint ("Info Button Tapped")
    }
    
    //MARK: - VC Lifecycle
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        addButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        debugPrint("The screen bounds are \(UIScreen.main.bounds)")
        debugPrint("The view bounds are \(self.view.bounds)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
