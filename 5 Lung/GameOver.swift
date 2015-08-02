//
//  GameOver.swift
//  trick
//
//  Created by 😎 on 6/27/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    
    let background = SKSpriteNode(imageNamed:"Lights")
    
    var totalLung: Int?
    var highLung: Int?
    let back = SKSpriteNode(imageNamed: "Menu")
    let again = SKSpriteNode(imageNamed: "Restart")
    
    func changeScene(newScene: SKScene) {
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.revealWithDirection(.Up, duration: 1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    override func didMoveToView(view: SKView) {
        
        background.size = self.frame.size
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.zPosition = -2
        self.addChild(background)
        
        backgroundColor = SKColor(red: 105/255, green: 220/255, blue: 255/255, alpha: 1.0)
        func pianoSound() {
            let ayy = Int(arc4random_uniform(6))
            var ayyy = "piano\(ayy).mp3"
            runAction(SKAction.playSoundFileNamed(ayyy, waitForCompletion: false))
        }
        pianoSound()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let highScore = defaults.stringForKey("highScore") {
            if count > highScore.toInt() {
                defaults.setObject(count, forKey: "highScore")
                highLung = count
            } else {
                highLung = highScore.toInt()
            }
        } else {
            println("else")
            highLung = count
            defaults.setObject(count, forKey: "highScore")
        }
        
        if let totalScore = defaults.stringForKey("totalScore") {
            var boob = totalScore.toInt()! + count
            totalLung = boob
            defaults.setObject(boob, forKey: "totalScore")
        } else {
            totalLung = count
            defaults.setObject(count, forKey: "totalScore")
        }
        
        let title = SKSpriteNode(imageNamed: "Game Over")
        title.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.8 )
        title.size = CGSize(width: 223, height: 140.5)
        self.addChild(title)
        
        let scoreboard = SKSpriteNode(imageNamed: "Scoreboard")
        scoreboard.size = CGSize(width: 273.5, height: 140)
        scoreboard.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addChild(scoreboard)
        
        var highScoreLabel = SKLabelNode(fontNamed: "KohinoorDevanagari-Medium")
        highScoreLabel.position = CGPoint(x: self.frame.size.width / 2 + 60, y: self.frame.size.height / 2 - 20)
        highScoreLabel.color = SKColor.yellowColor()
        highScoreLabel.zPosition = 10
        highScoreLabel.text = "\(highLung!)"
        self.addChild(highScoreLabel)
        
        var scoreText = SKLabelNode(fontNamed: "KohinoorDevanagari-Medium")
        scoreText.text = "\(count)"
        scoreText.zPosition = 10
        scoreText.position = CGPoint(x: self.frame.size.width / 2 - 60, y: self.frame.size.height / 2 - 20)
        self.addChild(scoreText)
        
        println("total score: \(totalLung!)")
        
        again.size = CGSize(width: 128, height: 42.5)
        again.position = CGPoint(x: self.frame.size.width / 2 + 72.75, y: self.frame.size.height / 2 - 105)
        again.zPosition = 5
        self.addChild(again)
        
        back.size = again.size
        back.position = CGPoint(x: self.frame.size.width / 2 - 72.75, y: self.frame.size.height / 2 - 105)
        back.zPosition = 6
        self.addChild(back)
        
        //let sparks = SKEmitterNode(fileNamed: "HiScore.sks")
        //sparks.position = highScoreLabel.position
        //self.addChild(sparks)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if again.containsPoint(location) {
                let playAgain = GameScene(size: self.size)
                changeScene(playAgain)
                
            } else if back.containsPoint(location) {
                let menu = mainMenu(size: self.size)
                changeScene(menu)
                
            }
        }
        
    }
}