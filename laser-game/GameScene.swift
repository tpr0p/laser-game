//
//  GameScene.swift
//  Laser-Game
//
//  Created by Thomas Propson on 9/24/16.
//  Copyright © 2016 com.thomaspropson. All rights reserved.
//
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    //VC Reference
    var viewController: GameViewController!
    
    //Nodes
    let sinusoid = SKShapeNode()
    var spriteFromHUD: SKSpriteNode?
    var movableNode: SKNode?
    var movedNode: SKNode?
    
    //SK Actions
    let enlargeWidget = SKAction.resize(toWidth: CGFloat(widgetSelectedSize.width), height: CGFloat(widgetSelectedSize.height), duration: 0.5)
    let resizeWidget = SKAction.resize(toWidth: CGFloat(widgetSize.width), height: CGFloat(widgetSize.height), duration: 0.5)
    
    //Sinusoid
    let animateStrokeShader = SKShader(fileNamed: "animateStroke.fsh")
    let drawFactor: Float = 0.001
    var strokeShader: SKShader!
    var strokeLengthUniform: SKUniform!
    var _strokeLengthFloat: Float = 0.0
    var strokeLengthKey: String!
    var strokeLengthFloat: Float {
        get {
            return _strokeLengthFloat
        }
        set( newStrokeLengthFloat ) {
            _strokeLengthFloat = newStrokeLengthFloat
            strokeLengthUniform.floatValue = newStrokeLengthFloat
        }
    }
    
    func shaderWithFilename( _ filename: String?, fileExtension: String?, uniforms: [SKUniform] ) -> SKShader {
        let path = Bundle.main.path( forResource: filename, ofType: fileExtension )
        let source = try! NSString( contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue )
        let shader = SKShader( source: source as String, uniforms: uniforms )
        return shader
    }
    
    func addSinusoid(){
        //Animating the Sinusoid
        strokeLengthKey = "u_current_percentage"
        strokeLengthUniform = SKUniform( name: strokeLengthKey, float: 0.0 )
        let uniforms: [SKUniform] = [strokeLengthUniform]
        strokeShader = shaderWithFilename( "animateStroke", fileExtension: "fsh", uniforms: uniforms )
        strokeLengthFloat = 0.0
        
        //Drawing the Sinusoid
        sinusoid.path = Sinusoid(from: CGPoint(x: 30,y: 30), to: CGPoint(x: 400, y: 300), frequency: 5, amplitude: 10).cgPath
        sinusoid.lineWidth = 3.0
        sinusoid.fillColor = SKColor.clear
        sinusoid.lineCap = .round
        sinusoid.strokeShader = strokeShader
        sinusoid.zPosition = 10
        addChild(sinusoid)
    }
    
    //Adding Widgets
    func addWidget(_ image: UIImage, at pos: CGPoint){
        let skPos = self.view?.convert(pos, to: self)
        let widget = SKSpriteNode()
        widget.size = widgetSize
        widget.texture = SKTexture(cgImage: image.cgImage!)
        widget.zPosition = CGFloat(101 + self.children.count)
        widget.position = skPos!
        self.addChild(widget)
    }
    
    override func didMove(to view: SKView) {
        addSinusoid()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Draw Sinusoid Update
        strokeLengthFloat += drawFactor
        if strokeLengthFloat > 1.0 {
            strokeLengthFloat = 0.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            for child in self.children {
                if child.contains(location) {
                    movableNode = child
                    movableNode!.position = location
                    movableNode?.alpha = 0.5
                    movableNode?.run(enlargeWidget)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode?.alpha = 1.0
            movableNode?.run(resizeWidget)
            movedNode = movableNode
            movableNode = nil
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            movableNode?.alpha = 1.0
            movableNode?.run(resizeWidget)
            movableNode = nil
        }
    }
}

