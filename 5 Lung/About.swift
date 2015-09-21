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
        let reveal = SKTransition.fadeWithDuration(1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    let tap = SKSpriteNode(imageNamed: "tap.png")
    
    let link = SKLabelNode(text: "Visit 5lung.tk 〉")
    
    let fall = SKAction.moveToY(UIScreen.mainScreen().bounds.height * 0.567, duration: 1.6)
    
    let actionwait = SKAction.waitForDuration(0.5)
    var timeSecond: Double = 0
    var reminded = false
    
    let backg = bg(lights: false) as SKSpriteNode
    let skeletrick = SKSpriteNode()
    let fadeOut = SKAction.fadeOutWithDuration(0.35)
    let fadeIn = SKAction.fadeInWithDuration(1)
    let rightUp = SKAction.moveByX(2.2, y: 1.5, duration: 0.5)
    let wait = SKAction.waitForDuration(1)
    var patricks = SKNode()
    var statics = SKNode()
    var others = SKNode()
    
    let bigtrick = SKSpriteNode(imageNamed: "fadedtrick.png")
    var rect = SKSpriteNode()
    let piano = SKSpriteNode(imageNamed: "Piano")
    let back = SKSpriteNode()
    let patrick = SKSpriteNode(imageNamed: "singingpatrick.png")
    let sadtrick = SKSpriteNode()
    let notes = SKLabelNode(fontNamed: "KohinoorDevanagari-Medium")
    let lights = SKSpriteNode(imageNamed: "Lights")
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(statics)
        self.addChild(patricks)
        self.addChild(others)
        
        statics.addChild(backg)
        
        self.physicsWorld.gravity = CGVectorMake(0, -7.6)
        physicsWorld.contactDelegate = self;
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        lights.size = CGSizeMake(width, height)
        lights.zPosition = 0
        lights.position = CGPointMake(width / 2, height / 2)
        statics.addChild(lights)
        
        piano.size = CGSize(width: self.frame.size.width * 0.21, height: self.frame.size.width * 0.146)
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
        
        let backtwo = SKLabelNode(text: "〈 Back")
        backtwo.fontName = "KohinoorDevanagari-Light"
        backtwo.horizontalAlignmentMode = .Left
        backtwo.fontSize = 20
        backtwo.fontColor = SKColor.whiteColor()
        backtwo.position = CGPointMake(height * 0.03, height * 0.95)
        statics.addChild(backtwo)
        
        
        link.position = CGPointMake(width * 0.96, height * 0.95)
        link.horizontalAlignmentMode = .Right
        link.fontSize = 20
        link.fontColor = SKColor.whiteColor()
        link.fontName = "KohinoorDevanagari-Light"
        self.addChild(link)
        
        
        bigtrick.position = CGPoint(x: width / 2, y: 0)
        let sizey = bigtrick.texture!.size()
        let boo = sizey.height * 0.9 * width / sizey.width
        bigtrick.size = CGSize(width: width * 0.9, height: boo)
        bigtrick.color = SKColor.whiteColor()
        bigtrick.colorBlendFactor = 0.2
        bigtrick.alpha = 0
        patricks.addChild(bigtrick)
        
        rect.texture = SKTexture(imageNamed: "Abt0")
        rect.size = CGSize(width: width * 0.95, height: width * 0.3884)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            rect.size.width = rect.size.width * 0.8
            rect.size.height = rect.size.height * 0.8
        }
        rect.position = CGPoint(x: width / 2, y: width * 0.22)
        rect.zPosition = 10
        statics.addChild(rect)
        
        
        var actionrun = SKAction.runBlock({
            self.timeSecond += 0.5
        })
        
        var patsition: CGFloat = rect.position.y * 2
        
        tap.size = CGSize(width: width * 0.244, height: 0.201 * width)
        tap.position.y = patsition + height * 0.378
        tap.position.x = width / 2 + height / 5
        func removeTap() {
            tap.removeFromParent()
        }
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,
            actionrun,
            SKAction.runBlock() {
                if self.n < 3 && self.timeSecond > 3.5 && self.reminded == false {
                    self.addChild(self.tap)
                    self.reminded = true
                }
            }
            ])))
        
        
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            patsition += height * 0.026
        }
        
        sadtrick.texture = SKTexture(imageNamed: "sadsmall.png")
        sadtrick.size = CGSize(width: height * 0.23415, height: height * 0.54)
        sadtrick.position = CGPoint(x: width / 2, y: patsition + sadtrick.size.height / 2)
        sadtrick.alpha = 0
        sadtrick.zPosition = 5
        sadtrick.physicsBody = SKPhysicsBody(rectangleOfSize: sadtrick.size)
        sadtrick.physicsBody?.dynamic = true
        sadtrick.physicsBody?.affectedByGravity = false
        patricks.addChild(sadtrick)
        
        notes.text = "🎶"
        notes.position = CGPoint(x: width * 0.66, y: patsition + sadtrick.size.height * 0.55)
        notes.alpha = 0
        notes.zPosition = 20
        statics.addChild(notes)
        notes.runAction(fadeIn)
        notes.runAction(rightUp)
        
        patrick.size = CGSizeMake(height * 0.187, height * 0.45)
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.46)
        patrick.zPosition = 3
        patricks.addChild(patrick)
        patrick.runAction(SKAction.scaleTo(1.25214, duration: 0.4))
        patrick.runAction(SKAction.moveToY(patsition + height * 0.2615, duration: 0.4))
        
        skeletrick.texture = SKTexture(imageNamed: "skeletrick.png")
        skeletrick.size = CGSize(width: height * 0.2811, height: height * 0.6304)
        skeletrick.position = CGPointMake(width * 0.462, patsition + skeletrick.size.height / 2)
        skeletrick.zPosition = 2
        skeletrick.alpha = 0
        patricks.addChild(skeletrick)
        
    }
    
    func lung(pos: CGFloat) {
        let lung = SKSpriteNode(imageNamed:"Lung")
        lung.position = CGPoint(x: self.frame.size.width * pos, y: self.frame.size.height + 50)
        lung.size = GameScene().lungSize()
        others.addChild(lung)
        let hide = SKAction.runBlock() {
            lung.hidden = true
        }
        lung.runAction(SKAction.sequence([wait, fall, hide]))
    }
    
    func GO(n: CGFloat) {
        lung(n)
        let shrink = SKAction.scaleBy(0.8, duration: 0.5)
        let run = SKAction.moveToX(self.frame.size.width * n, duration: 0.6)
        sadtrick.runAction(SKAction.moveToY(sadtrick.position.y - sadtrick.size.height * 0.1, duration: 0.6))
        let actrick = SKAction.sequence([shrink, wait, run])
        sadtrick.runAction(actrick)
    }
    
    var n: Int = 0
    
    let timeWait = [0.5, 1, 0.5, 4, 0]
    
    var touchCount = 0
    func endTouch(location: CGPoint) {
        if n < 5 {
            var a = "Abt\(n)"
            if reminded {
                tap.removeFromParent()
            }
            rect.texture = SKTexture(imageNamed: a)
        }
        switch n {
        case 1:
            notes.runAction(rightUp)
            notes.runAction(fadeOut)
            lights.runAction(SKAction.fadeOutWithDuration(0.35))
            backg.runAction(SKAction.colorizeWithColorBlendFactor(0.05, duration: 0.42))
            sadtrick.runAction(fadeIn)
            patrick.runAction(SKAction.sequence([wait,fadeOut]))
        case 2:
            skeletrick.runAction(SKAction.fadeAlphaTo(1, duration: 1))
            sadtrick.runAction(fadeOut)
            notes.runAction(fadeOut)
            notes.removeFromParent()
        case 3:
            sadtrick.texture = SKTexture(imageNamed: "Patrick")
            skeletrick.runAction(fadeOut)
            sadtrick.runAction(fadeIn)
            backg.runAction(SKAction.colorizeWithColorBlendFactor(0, duration: 1))
            self.GO(0.35)
            self.runAction(SKAction.sequence([
                wait,
                SKAction.runBlock() {
                    self.GO(0.6)
                },
                ]))
        case 4:
            others.addChild(piano)
            skeletrick.removeFromParent()
            bigtrick.runAction(SKAction.sequence([
                wait,
                wait,
                SKAction.fadeAlphaTo(0.35, duration: 3.5),
                wait,
                SKAction.fadeAlphaTo(0.9, duration: 5)
                ]))
            bigtrick.runAction(SKAction.sequence([
                wait,
                wait,
                SKAction.moveToY(bigtrick.size.height / 2 + rect.position.y + 30, duration: 2.4)
                ]))
            n++
        default:
            ()
        }
        timeSecond = 0
        touchCount = 0
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            touchCount++
            let location = touch.locationInNode(self)
            if back.containsPoint(location) {
                let newScene = mainMenu(size: self.size)
                changeScene(newScene)
            } else if link.containsPoint(location) {
                if let requestUrl = NSURL(string: "http://5lung.tk") {
                    UIApplication.sharedApplication().openURL(requestUrl)
                }
            }
            else if n >= 5 && rect.containsPoint(location) {
                let newScene = GameScene(size: self.size)
                changeScene(newScene)
            } else {
                if touchCount == 1 && n < 4 {
                    n++
                    if timeSecond >= timeWait[n-1] {
                        endTouch(location)
                    } else {
                        self.runAction(SKAction.sequence([
                            SKAction.waitForDuration(NSTimeInterval(timeWait[n-1] - timeSecond)),
                            SKAction.runBlock() {
                                self.endTouch(location)
                            },
                            ]))
                    }
                }
            }
        }
    }
}