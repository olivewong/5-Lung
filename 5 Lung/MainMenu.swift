//
//  MainMenu.swift
//  trick
//
//  Created by 😎 on 7/5/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class mainMenu: SKScene {
    
    let patrick = SKSpriteNode(imageNamed: "singingpatrick.png")
    
    func changeScene(newScene: SKScene, transition: SKTransition) {
        newScene.scaleMode = scaleMode
        self.view?.presentScene(newScene, transition: transition)
    }
        class Button: SKSpriteNode {
        let screenSize = UIScreen.mainScreen().bounds
        init(texture: String, name: String, xpos: CGFloat) {
            let texture = SKTexture(imageNamed: texture)
            super.init(texture: texture, color: nil, size: CGSizeMake(CGFloat(screenSize.height * 0.11), CGFloat(screenSize.height * 0.11)))
            self.name = name
            self.position.y = screenSize.height * 0.134
            self.position.x = screenSize.width * xpos
        }
        func touchDown() {
            self.position.y -= 5
        }
        func touchUp() {
            self.position.y += 5
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func didMoveToView(view: SKView) {
        let height = self.frame.size.height
        let width = self.frame.size.width

        let background = SKSpriteNode(imageNamed: "Lights")
        background.size = CGSize(width: width, height: height)
        background.position = CGPoint(x: width / 2, y: height / 2)
        background.zPosition = -2
        self.addChild(background)
        
        let q = Button(texture: "q.png", name: "about", xpos: 0.75)
        self.addChild(q)
        
        let play = Button(texture: "play.png", name: "play", xpos: 0.5)
        self.addChild(play)
        
        let music = Button(texture: "Music", name: "music", xpos: 0.25)
        self.addChild(music)
        
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 - 15)
        patrick.size = CGSizeMake(height * 0.187, height * 0.45)
        patrick.zPosition = 5
        self.addChild(patrick)
        
        let title = SKSpriteNode(imageNamed: "Title")
        title.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.78 )
        title.size = title.texture!.size()
        title.zPosition = 5
        self.addChild(title)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodey = self.nodeAtPoint(location)
            if let myClass = nodey as? Button {
                myClass.touchDown()
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodey = self.nodeAtPoint(location)
            if let myClass = nodey as? Button {
                myClass.touchUp()
            }
            if let name = nodey.name {
                if name == "play" {
                    let newScene = GameScene(size: self.size)
                    changeScene(newScene, transition: SKTransition.revealWithDirection(.Up, duration: 1.5))
                } else if name == "about" {
                    patrick.runAction(SKAction.moveTo(CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 + 15), duration: 0.6))
                    let newScene = about(size: self.size)
                    self.changeScene(newScene, transition: SKTransition.crossFadeWithDuration(1.5))
                } else if name == "music" {
                    if let spriteNode = nodey as? SKSpriteNode {
                        spriteNode.texture = SKTexture(imageNamed: "No Music")
                    }
                }
            }
        }
    }
}