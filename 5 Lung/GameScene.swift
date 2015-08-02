//
//  GameScene.swift
//  5lung
//
//  Created by 😎 on 6/26/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//


// AD D SAVE SCORE FUNC THAT RESETS WHEN U RESET GAME

import SpriteKit
var count = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let bg = SKSpriteNode(imageNamed: "No Lights")
    let patrick = SKSpriteNode(imageNamed: "Patrick")
    var score = SKLabelNode(fontNamed: "Superclarendon-Light")
    let scoreBG = SKSpriteNode(imageNamed: "Score")
    
    
    struct physicsCategory {
        static let None : UInt32 = 0 // 0
        static let Trick : UInt32 = 0b1 //1
        static let lung : UInt32 = 0b10 //2
        static let Border : UInt32 = 0b100 //4
        static let All : UInt32 = UInt32.max
    }
    
    var lungPool: [SKSpriteNode] = []
    
    func xPos() -> CGFloat {
        var pos = CGFloat(arc4random_uniform(100))
        if pos > 70 {
            pos -= (CGFloat(arc4random_uniform(40)) + 15)
        } else if pos < 30 {
            pos += (CGFloat(arc4random_uniform(40)) + 15)
        }
        pos = pos/100
        return pos
    }
    func spinny() -> CGFloat {
        var rot = CGFloat(arc4random_uniform(40)) / 10
        if arc4random_uniform(2) == 1 {
            rot = rot * -1
        }
        return rot
    }
    func lungSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return(CGSizeMake(CGFloat(screenSize.width * 0.1), CGFloat(screenSize.width * 0.138)))
        } else {
            return(CGSizeMake(CGFloat(screenSize.width * 0.13), CGFloat(screenSize.width * 0.18)))
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        count = 0
        let screenSize = UIScreen.mainScreen().bounds
        
        
        class Lung: SKSpriteNode {
            
            let screenSize = UIScreen.mainScreen().bounds
            init() {
                super.init(texture: SKTexture(imageNamed: "Lung"), color: nil, size: GameScene().lungSize())
                self.name = name
                self.position = CGPoint(x: self.frame.size.width * GameScene().xPos(), y: self.frame.size.height + 80)
                self.hidden = true
                self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
                self.physicsBody?.affectedByGravity = false
                self.physicsBody?.dynamic = true
                self.name = "lung"
                self.zPosition = 5
                self.position = CGPoint(x: self.frame.size.width * GameScene().xPos(), y: self.frame.size.height + 80)
                self.physicsBody?.usesPreciseCollisionDetection = true
                self.physicsBody?.allowsRotation = true
                self.physicsBody?.angularVelocity = GameScene().spinny()
                self.physicsBody?.categoryBitMask = physicsCategory.lung
                self.physicsBody?.collisionBitMask = physicsCategory.None
                self.physicsBody?.contactTestBitMask = physicsCategory.Trick | physicsCategory.Border
            }
            required init(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        func addLung(lung: Lung) {
            lungPool.append(lung)
            self.addChild(lung)
        }
        
        for i in 0...7 {
            addLung(Lung())
        }
        lungPool += [Lung(), Lung(), Lung(), Lung()]
        
        /* Setup your scene here */
        backgroundColor = SKColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
        self.physicsWorld.gravity = CGVectorMake(0, -1.6)
        physicsWorld.contactDelegate = self;
        self.physicsBody?.categoryBitMask = physicsCategory.Border
        self.physicsBody?.collisionBitMask = physicsCategory.lung
        self.physicsBody?.contactTestBitMask = physicsCategory.lung
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        bg.size = self.frame.size
        bg.zPosition = -1
        bg.position = CGPointMake(width / 2, self.frame.size.height / 2)
        self.addChild(bg)
        
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: 0)
        patrick.anchorPoint = CGPoint(x: 0, y: 0)
        patrick.size = CGSize(width: width / 4, height: width * 0.55693)
        patrick.lightingBitMask = 0
        patrick.physicsBody = SKPhysicsBody(rectangleOfSize: patrick.size)
        patrick.physicsBody?.dynamic = true
        patrick.physicsBody?.affectedByGravity = false
        patrick.physicsBody?.categoryBitMask = physicsCategory.Trick
        patrick.physicsBody?.collisionBitMask = physicsCategory.None
        patrick.physicsBody?.contactTestBitMask = physicsCategory.lung
        patrick.name = "mr. stump"
        self.addChild(patrick)
        
        scoreBG.size = CGSizeMake(154.5, 54.25)
        scoreBG.anchorPoint = CGPointMake(0, 1)
        scoreBG.position = CGPoint(x: 15, y: self.frame.size.height - 15)
        scoreBG.zPosition = 30
        self.addChild(scoreBG)
        
        score.position = CGPoint(x: scoreBG.size.width * 0.833 + 12, y: self.frame.size.height - 40.25)
        score.fontSize = 25
        score.text = "\(count)"
        score.verticalAlignmentMode = .Center
        score.zPosition = 105
        self.addChild(score)
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            /* Called when a touch begins */
            var right = SKAction.moveByX(40, y: 0, duration: 0.5)
            var left = SKAction.moveByX(-40, y: 0, duration: 0.5)
            var touchPosition = touch.locationInNode(self).x
            var patrickPosition = patrick.position.x
            let location = (touch as! UITouch).locationInNode(self)
            
            if Float(touchPosition) > Float(patrickPosition) {
                patrick.runAction(right)
            }
            else {
                patrick.runAction(left)
            }
        }
    }
    
    func positioner(#follow: Bool) -> CGFloat {
        var n: CGFloat = (CGFloat(arc4random_uniform(30)) + 35)
        n = n/100
        if follow && Int(arc4random_uniform(2)) == 1 {
            n = CGFloat(patrick.position.x)
        } else {
            n = self.frame.size.width * n
        }
        return(CGFloat(n))
        
    }
    
    func returnLung(lung: SKNode) {
        lung.physicsBody?.affectedByGravity = false
        println("returning lung")
        lung.runAction(
            SKAction.sequence([
                SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
                SKAction.waitForDuration(0.1),
                SKAction.runBlock() {
                    lung.hidden = true
                }
                ]))
    }
    
    let shrink = SKAction.scaleBy(0.5, duration: 0.1)
    let fade = SKAction.fadeOutWithDuration(0.3)
    
    func didBeginContact(contact: SKPhysicsContact) {
        var contactBody1: SKPhysicsBody
        var contactBody2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactBody1 = contact.bodyA
            contactBody2 = contact.bodyB
        } else {
            contactBody1 = contact.bodyB
            contactBody2 = contact.bodyA
        }
        if((contactBody1.categoryBitMask == 1) && (contactBody2.categoryBitMask == 2)) {
            switch contactBody2.node!.name! {
            case "lung":
                count++
                returnLung(contactBody2.node!)
            case "keys":
                contactBody1.node!.physicsBody?.affectedByGravity = true
                let newScene = GameOver(size: self.size)
                newScene.scaleMode = scaleMode
                let reveal = SKTransition.revealWithDirection(.Down, duration: 1.5)
                self.view?.presentScene(newScene, transition: reveal)
            default:
                ()
            }
        }
        if((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 2)) {
            returnLung(contactBody1.node!)
        }
    }
    
    func createPianoNode(pos: CGFloat) {
        var piano = SKSpriteNode(imageNamed: "Piano")
        piano.size = CGSize(width: 84.8, height: 58.4)
        piano.position = CGPoint(x: pos, y: self.frame.size.height + 50)
        piano.physicsBody = SKPhysicsBody(rectangleOfSize: piano.size)
        piano.physicsBody?.affectedByGravity = true
        piano.name = "keys"
        piano.physicsBody?.usesPreciseCollisionDetection = true
        piano.physicsBody?.categoryBitMask = physicsCategory.lung
        piano.physicsBody?.collisionBitMask = physicsCategory.Border
        piano.physicsBody?.contactTestBitMask = physicsCategory.Trick
        piano.zPosition = 90
        self.addChild(piano)
    }
    
    var findLung = false
    
    func moveLung(lung: SKSpriteNode) {
        lung.physicsBody?.velocity = CGVectorMake(0, 0);
        lung.physicsBody?.angularVelocity = spinny()
        lung.position.y = self.frame.size.height + 30
        lung.hidden = false
        lung.position.x = self.frame.size.width * xPos()
        lung.physicsBody?.affectedByGravity = true
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        score.text = "\(count)"
        
        switch Int(arc4random_uniform(130)) {
        case 1...3:
            findLung = true
            while findLung {
                for i in 0...5 {
                    if lungPool[i].hidden {
                        if findLung == true {
                            moveLung(lungPool[i])
                            findLung = false
                        }
                    }
                }
                findLung = false
            }
            
        case 5:
            createPianoNode(positioner(follow: true))
        case 7...10:
            print(lungPool.count)
        default:
            ()
        }
        
    }
    
}
