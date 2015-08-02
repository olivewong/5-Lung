//
//  About.swift
//  trick
//
//  Created by 😎 on 7/10/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
class about: SKScene, SKPhysicsContactDelegate {
    func changeScene(newScene: SKScene) {
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.revealWithDirection(.Right, duration: 1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    //actions
    let skeletrick = SKSpriteNode()
    let fadeOut = SKAction.fadeOutWithDuration(0.5)
    let fadeIn = SKAction.fadeInWithDuration(1)
    let rightUp = SKAction.moveByX(2.2, y: 1.5, duration: 0.5)
    let fall = SKAction.moveToY(350, duration: 1.4)
    let wait = SKAction.waitForDuration(1)
    
    var bg = SKSpriteNode(imageNamed:"No Lights")
    let bigtrick = SKSpriteNode(imageNamed: "sad.png")
    var rect = SKSpriteNode()
    let piano = SKSpriteNode(imageNamed: "Piano")
    let back = SKSpriteNode(imageNamed: "Back")
    let patrick = SKSpriteNode()
    let sadtrick = SKSpriteNode()
    let notes = SKLabelNode(fontNamed: "KohinoorDevanagari-Medium")
    let lights = SKSpriteNode(imageNamed: "Lights")
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVectorMake(0, -7.6)
        physicsWorld.contactDelegate = self;
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        lights.size = CGSizeMake(width, height)
        lights.zPosition = 0
        lights.position = CGPointMake(width / 2, height / 2)
        self.addChild(lights)
        
        piano.size = CGSize(width: 84.8, height: 58.4)
        piano.position = CGPoint(x: width * 0.65, y: height + 50)
        piano.physicsBody = SKPhysicsBody(rectangleOfSize: piano.size)
        piano.physicsBody?.dynamic = true
        piano.physicsBody?.affectedByGravity = true
        
        back.size = CGSize(width: width / 4, height: width * 0.127)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            back.size.width = back.size.width * 0.65
            back.size.height = back.size.height * 0.65
        }
        back.position = CGPoint(x: 10, y: height - 10)
        back.anchorPoint = CGPointMake(0, 1)
        self.addChild(back)
        notes.text = "🎶"
        notes.position = CGPoint(x: width / 2 + 40, y: height / 2 + 45)
        notes.alpha = 0
        notes.zPosition = 20
        self.addChild(notes)
        notes.runAction(fadeIn)
        notes.runAction(rightUp)
        
        bigtrick.position = CGPoint(x: width / 2, y: 0)
        bigtrick.size = CGSize(width: width * 0.8, height: width * 1.053)
        bigtrick.alpha = 0
        self.addChild(bigtrick)
        
        rect.texture = SKTexture(imageNamed: "Abt0")
        rect.size = CGSize(width: width * 0.95, height: width * 0.3884)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            rect.size.width = rect.size.width * 0.8
            rect.size.height = rect.size.height * 0.8
        }
        rect.position = CGPoint(x: width / 2, y: width * 0.22)
        rect.zPosition = 10
        self.addChild(rect)
        
        let patsition: CGFloat = rect.position.y * 2
        
        patrick.texture = SKTexture(imageNamed: "singingpatrick.png")
        patrick.size = CGSizeMake(height * 0.187, height * 0.45)
        patrick.position = CGPoint(x: width * 0.5, y: height / 2 - 15)
        self.addChild(patrick)
        patrick.runAction(SKAction.scaleTo(1.25214, duration: 0.4))
        //move to half of patrick's (post-scale) height (0.2817) - the difference between him and sadtrick .563463/2 - (.563463-.54)
        patrick.runAction(SKAction.moveToY(patsition + height * 0.2583, duration: 0.4))

        sadtrick.texture = SKTexture(imageNamed: "sadsmall.png")
        sadtrick.size = CGSize(width: height * 0.23415, height: height * 0.54)
        //sadtrick.position = CGPoint(x: width / 2, y: patsition + height * sadtrick.size.height / 2)
        sadtrick.position = CGPoint(x: width / 2, y: patsition + sadtrick.size.height / 2)
        sadtrick.alpha = 0
        sadtrick.zPosition = 3
        sadtrick.physicsBody = SKPhysicsBody(rectangleOfSize: sadtrick.size)
        sadtrick.physicsBody?.dynamic = true
        sadtrick.physicsBody?.affectedByGravity = false
        self.addChild(sadtrick)
        
        skeletrick.texture = SKTexture(imageNamed: "skeletrick.png")
        skeletrick.size = CGSize(width: height * 0.2811, height: height * 0.6304)
        skeletrick.position = CGPointMake(width * 0.462, patsition + skeletrick.size.height / 2)
        skeletrick.zPosition = 2
        skeletrick.alpha = 0
        self.addChild(skeletrick)
        
        bg.position = CGPoint(x: width / 2, y: height / 2)
        bg.zPosition = -2
        bg.color = SKColor.blackColor()
        bg.size = CGSizeMake(width, height)
        self.addChild(bg)
    }
    
    func lung(pos: CGFloat) {
        let lung = SKSpriteNode(imageNamed:"Lung")
        lung.position = CGPoint(x: self.frame.size.width * pos, y: self.frame.size.height + 50)
        lung.size = CGSize(width: 33.544, height: 46.552)
        self.addChild(lung)
        let hide = SKAction.runBlock() {
            lung.hidden = true
        }
        lung.runAction(SKAction.sequence([wait, fall, hide]))
    }
    
    func GO(n: CGFloat) {
        lung(n)
        let shrink = SKAction.scaleBy(0.8, duration: 0.5)
        let run = SKAction.moveToX(self.frame.size.width * n, duration: 0.6)
        sadtrick.runAction(SKAction.moveToY(CGFloat(320.0), duration: 0.6))
        let actrick = SKAction.sequence([shrink, wait, run])
        sadtrick.runAction(actrick)
    }
    
    var n: Int = 0
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            n += 1
            switch n {
                case 1:
                    notes.runAction(rightUp)
                    notes.runAction(fadeOut)
                case 2:
                    ()
                    //bg.runAction(SKAction.colorizeWithColorBlendFactor(0.5, duration: 1))
                case 3:
                    sadtrick.texture = SKTexture(imageNamed: "Patrick")
                    skeletrick.runAction(fadeOut)
                    sadtrick.runAction(fadeIn)
                    bg.runAction(SKAction.colorizeWithColorBlendFactor(0, duration: 1))
                default:
                    println("tiddies")
            }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if n < 5 {
                var a = "Abt\(n)"
                rect.texture = SKTexture(imageNamed: a)
            }
            let location = touch.locationInNode(self)
            if back.containsPoint(location) {
                let newScene = mainMenu(size: self.size)
                changeScene(newScene)
            } else {
                switch n {
                case 1:
                    lights.runAction(SKAction.fadeOutWithDuration(0.35))
                    bg.runAction(SKAction.colorizeWithColorBlendFactor(0.1, duration: 0.42))
                    sadtrick.runAction(fadeIn)
                    patrick.runAction(SKAction.sequence([wait,fadeOut]))
                case 2:
                    //bg.color = SKColor(red: 21/255, green: 155/255, blue: 113/255, alpha: 1)
                    skeletrick.runAction(SKAction.fadeAlphaTo(1, duration: 1))
                    sadtrick.runAction(fadeOut)
                    notes.runAction(fadeOut)
                    notes.removeFromParent()
                case 3:
                    self.GO(0.35)
                    self.runAction(SKAction.sequence([
                        wait,
                        SKAction.runBlock() {
                            self.GO(0.6)
                        },
                        ]))
                case 4:
                    self.addChild(piano)
                    bigtrick.runAction(SKAction.sequence([
                        wait,
                        SKAction.fadeAlphaTo(0.5, duration: 2.5)
                        ]))
                    bigtrick.runAction(SKAction.moveToY(bigtrick.size.height / 2 + rect.position.y + 30, duration: 2.4))
                case 5:
                    if rect.containsPoint(location) {
                        let newScene = GameScene(size: self.size)
                        changeScene(newScene)
                    }
                default:
                    ()
                }
            }
        }
    }
}