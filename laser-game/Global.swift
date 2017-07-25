//
//  Global.swift
//  Laser-Game
//
//  Created by Thomas Propson on 9/19/16.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//

import UIKit
import SpriteKit

// Color Wheels
// Primary and Secondary Color Wheel
let psColorWheel: [CGColor] = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor]
let psColorWheelLoop: [CGColor] = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.red.cgColor]
// Custom Color Wheel
let customColorWheel: [CGColor] = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.magenta.cgColor]
let customColorWheelLoop: [CGColor] = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.magenta.cgColor,UIColor.red.cgColor]

// Screen Size Modifiers
let screenSize: CGRect = UIScreen.main.bounds
// When multiplied by this variable, the given WIDTH will conform to iPhone SE bounds
var seW = (UIScreen.main.bounds.width/568)
// When multiplied by this variable, the given HEIGHT will conform to iPhone SE bounds
var seH = (UIScreen.main.bounds.height/320)
// Screen Scale
let screenScale = UIScreen.main.scale
//Node Vars
//Widget Sizes for SpriteKit Actions
let widgetSize = CGSize(width:25,height:25)
let widgetSelectedSize = (width:25*1.25,height:25*1.25)

