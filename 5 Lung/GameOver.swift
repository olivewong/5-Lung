//
//  GameOver.swift
//  trick
//
//  Created by 😎 on 6/27/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOver: SKScene {
    
    class overButton: SKSpriteNode {
        
        let screenSize = UIScreen.mainScreen().bounds
        init(txt: String, y: CGFloat) {
            let sizey: CGSize = scoreboardSize()
            let gap = screenSize.width * 0.035
            let width = ((sizey.width - gap) * 0.5)
            super.init(texture: SKTexture(imageNamed: txt), color: SKColor.redColor(), size: CGSize(width: width, height: width * 0.3322))
            self.position = CGPoint(x: screenSize.width / 2, y: y)
            let remainder = (screenSize.width - sizey.width) / 2
            if txt == "menu.png" {
                self.name = "menu"
                self.anchorPoint = CGPoint(x: 0, y: 1)
                self.position.x = remainder
            } else if txt == "restart.png" {
                self.name = "restart"
                self.anchorPoint = CGPoint(x: 1, y: 1)
                self.position.x = screenSize.width - remainder
            }
            self.zPosition = 15
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    var totalLung: Int?
    var highLung: Int?
    
    func changeScene(newScene: SKScene) {
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.revealWithDirection(.Up, duration: 1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    override func didMoveToView(view: SKView) {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let gap = width * 0.035
        
        self.addChild(bg(lights: true))
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let highScore = defaults.stringForKey("highScore") {
            if count > Int(highScore) {
                defaults.setObject(count, forKey: "highScore")
                highLung = count
            } else {
                highLung = Int(highScore)
            }
        } else {
            highLung = count
            defaults.setObject(count, forKey: "highScore")
        }
        
        if let totalScore = defaults.stringForKey("totalScore") {
            var boob = Int(totalScore)! + count
            totalLung = boob
            defaults.setObject(boob, forKey: "totalScore")
        } else {
            totalLung = count
            defaults.setObject(count, forKey: "totalScore")
        }

        
        let title = SKSpriteNode(imageNamed:
            "Game Over.png")
        title.position = CGPoint(x: self.frame.size.width / 2, y: height * 0.75)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            title.size = CGSize(width: width * 0.7, height: width * 0.474)
        } else {
            title.size = CGSize(width: width * 0.8, height: width * 0.54)
        }
        self.addChild(title)
        
        let scoreboard = SKSpriteNode(imageNamed: "Scoreboard.png")
        scoreboard.size = scoreboardSize()
        scoreboard.position = CGPoint(x: self.frame.size.width / 2, y: title.position.y - title.size.height / 2 - gap*2 - scoreboard.size.height / 2)
        self.addChild(scoreboard)
        
        let back = overButton(txt: "menu.png", y: scoreboard.position.y - (gap + scoreboardSize().height / 2))
        let again = overButton(txt: "restart.png", y: scoreboard.position.y - (gap + scoreboardSize().height / 2))
        
        self.addChild(back)
        self.addChild(again)
        
        let highScoreLabel = SKLabelNode(text: "\(highLung!)")
        highScoreLabel.fontName = "Superclarendon-Regular"
        highScoreLabel.position = CGPoint(x: scoreboard.position.x + scoreboard.size.width * 0.235, y: scoreboard.position.y - scoreboard.size.height * 0.093)
        highScoreLabel.verticalAlignmentMode = .Center
        highScoreLabel.zPosition = 5
        highScoreLabel.fontSize = scoreboard.size.height * 0.23
        
        self.addChild(highScoreLabel)
        
        
        let scoreText = highScoreLabel.copy() as! SKLabelNode
        scoreText.text = "\(count)"
        scoreText.position.x = scoreboard.position.x - scoreboard.size.width * 0.235
        self.addChild(scoreText)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = (touch as! UITouch).locationInNode(self)
            let nodey = self.nodeAtPoint(location)
            
            if let butt = nodey as? overButton {
                if butt.name == "restart" {
                    let playAgain = GameScene(size: self.size)
                    changeScene(playAgain)
                    
                } else if butt.name == "menu" {
                    let menu = mainMenu(size: self.size)
                    changeScene(menu)
                }
            }
        }
        
    }
}