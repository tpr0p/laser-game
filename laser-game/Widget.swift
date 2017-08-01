//
//  Widget.swift
//  Laser-Game
//
//  Created by Thomas Propson on 7/25/17.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
//

import UIKit

class Widget: UIImageView{
    
    //MARK: - Properties
    
    var name: String
    
    //MARK: - Constructors
    
    override init(frame: CGRect) {
        name = ""
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    
    
}
