//
//  Widget.swift
//  Laser-Game
//
//  Created by Thomas Propson on 7/25/17.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
//

import UIKit

struct Widget{
    var name: String
    var image: UIImage
    
    init(name: String) {
        self.name = name
        image = UIImage(named: name)!
    }
}
