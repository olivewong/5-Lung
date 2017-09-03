
import Foundation
import SpriteKit
import UIKit

class about: SKScene, SKPhysicsContactDelegate {
    func changeScene(_ newScene: SKScene) {
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.fade(withDuration: 1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    let tap = SKSpriteNode(imageNamed: "tap.png")
    
    let link = SKLabelNode(text: "Visit 5lung.tk 〉")
    
    let fall = SKAction.moveTo(y: UIScreen.main.bounds.height * 0.567, duration: 1.6)
    
    let actionwait = SKAction.wait(forDuration: 0.5)
    var timeSecond: Double = 0
    var reminded = false
    
    let backg = bg(lights: false) as SKSpriteNode
    let skeletrick = SKSpriteNode()
    let fadeOut = SKAction.fadeOut(withDuration: 0.35)
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let rightUp = SKAction.moveBy(x: 2.2, y: 1.5, duration: 0.5)
    let wait = SKAction.wait(forDuration: 1)
    var patricks = SKNode()
    var statics = SKNode()
    var others = SKNode()
    
    let bigtrick = SKSpriteNode(imageNamed: "fadedtrick.png")
    var rect = SKSpriteNode()
    let piano = SKSpriteNode(imageNamed: "Piano.png")
    let back = SKSpriteNode()
    let patrick = SKSpriteNode(imageNamed: "singingpatrick.png")
    let sadtrick = SKSpriteNode()
    let notes = SKLabelNode(fontNamed: "KohinoorDevanagari-Medium")
    let lights = SKSpriteNode(imageNamed: "Lights.png")
    
    override func didMove(to view: SKView) {
        
        self.addChild(statics)
        self.addChild(patricks)
        self.addChild(others)
        
        statics.addChild(backg)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7.6)
        physicsWorld.contactDelegate = self;
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        lights.size = CGSize(width: width, height: height)
        lights.zPosition = 0
        lights.position = CGPoint(x: width / 2, y: height / 2)
        statics.addChild(lights)
        
        piano.size = CGSize(width: self.frame.size.width * 0.21, height: self.frame.size.width * 0.146)
        piano.position = CGPoint(x: width * 0.65, y: height + 50)
        piano.physicsBody = SKPhysicsBody(rectangleOf: piano.size)
        piano.physicsBody?.isDynamic = true
        piano.physicsBody?.affectedByGravity = true
        
        back.size = CGSize(width: width / 4, height: width * 0.127)
        if UIDevice.current.userInterfaceIdiom == .pad {
            back.size.width = back.size.width * 0.65
            back.size.height = back.size.height * 0.65
        }
        back.position = CGPoint(x: 10, y: height - 10)
        back.anchorPoint = CGPoint(x: 0, y: 1)
        
        let backtwo = SKLabelNode(text: "〈 Back")
        backtwo.fontName = "KohinoorDevanagari-Light"
        backtwo.horizontalAlignmentMode = .left
        backtwo.fontSize = 20
        backtwo.fontColor = SKColor.white
        backtwo.position = CGPoint(x: height * 0.03, y: height * 0.95)
        statics.addChild(backtwo)
        
        
        link.position = CGPoint(x: width * 0.96, y: height * 0.95)
        link.horizontalAlignmentMode = .right
        link.fontSize = 20
        link.fontColor = SKColor.white
        link.fontName = "KohinoorDevanagari-Light"
        self.addChild(link)
        
        
        bigtrick.position = CGPoint(x: width / 2, y: 0)
        let sizey = bigtrick.texture!.size()
        let bigTrickHeight = sizey.height * 0.9 * width / sizey.width
        bigtrick.size = CGSize(width: width * 0.9, height: bigTrickHeight)
        bigtrick.color = SKColor.white
        bigtrick.colorBlendFactor = 0.2
        bigtrick.alpha = 0
        patricks.addChild(bigtrick)
        
        rect.texture = SKTexture(imageNamed: "abt0.png")
        rect.size = CGSize(width: width * 0.95, height: width * 0.3884)
        if UIDevice.current.userInterfaceIdiom == .pad {
            rect.size.width = rect.size.width * 0.8
            rect.size.height = rect.size.height * 0.8
        }
        rect.position = CGPoint(x: width / 2, y: width * 0.22)
        rect.zPosition = 10
        statics.addChild(rect)
        
        
        var actionrun = SKAction.run({
            self.timeSecond += 0.5
        })
        
        var patsition: CGFloat = rect.position.y * 2
        
        tap.size = CGSize(width: width * 0.244, height: 0.201 * width)
        tap.position.y = patsition + height * 0.378
        tap.position.x = width / 2 + height / 5
        func removeTap() {
            tap.removeFromParent()
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([actionwait,
            actionrun,
            SKAction.run() {
                if self.n < 3 && self.timeSecond > 3.5 && self.reminded == false {
                    self.addChild(self.tap)
                    self.reminded = true
                }
            }
            ])))
        
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            patsition += height * 0.026
        }
        
        sadtrick.texture = SKTexture(imageNamed: "sadsmall.png")
        sadtrick.size = CGSize(width: height * 0.23415, height: height * 0.54)
        sadtrick.position = CGPoint(x: width / 2, y: patsition + sadtrick.size.height / 2)
        sadtrick.alpha = 0
        sadtrick.zPosition = 5
        sadtrick.physicsBody = SKPhysicsBody(rectangleOf: sadtrick.size)
        sadtrick.physicsBody?.isDynamic = true
        sadtrick.physicsBody?.affectedByGravity = false
        patricks.addChild(sadtrick)
        
        notes.text = "🎶"
        notes.position = CGPoint(x: width * 0.66, y: patsition + sadtrick.size.height * 0.55)
        notes.alpha = 0
        notes.zPosition = 20
        statics.addChild(notes)
        notes.run(fadeIn)
        notes.run(rightUp)
        
        patrick.size = CGSize(width: height * 0.187, height: height * 0.45)
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.46)
        patrick.zPosition = 3
        patricks.addChild(patrick)
        patrick.run(SKAction.scale(to: 1.25214, duration: 0.4))
        patrick.run(SKAction.moveTo(y: patsition + height * 0.2615, duration: 0.4))
        
        skeletrick.texture = SKTexture(imageNamed: "skeletrick.png")
        skeletrick.size = CGSize(width: height * 0.2811, height: height * 0.6304)
        skeletrick.position = CGPoint(x: width * 0.462, y: patsition + skeletrick.size.height / 2)
        skeletrick.zPosition = 2
        skeletrick.alpha = 0
        patricks.addChild(skeletrick)
        
    }
    
    func lung(_ pos: CGFloat) {
        let lung = SKSpriteNode(imageNamed:"Lung.png")
        lung.position = CGPoint(x: self.frame.size.width * pos, y: self.frame.size.height + 50)
        lung.size = GameScene().lungSize()
        others.addChild(lung)
        let hide = SKAction.run() {
            lung.isHidden = true
        }
        lung.run(SKAction.sequence([wait, fall, hide]))
    }
    
    func GO(_ n: CGFloat) {
        lung(n)
        let shrink = SKAction.scale(by: 0.8, duration: 0.5)
        let run = SKAction.moveTo(x: self.frame.size.width * n, duration: 0.6)
        sadtrick.run(SKAction.moveTo(y: sadtrick.position.y - sadtrick.size.height * 0.1, duration: 0.6))
        let actrick = SKAction.sequence([shrink, wait, run])
        sadtrick.run(actrick)
    }
    
    var n: Int = 0
    
    let timeWait = [0.5, 1, 0.5, 4, 0]
    
    var touchCount = 0
    func endTouch(_ location: CGPoint) {
        if n < 5 {
            let a = "abt\(n).png"
            if reminded {
                tap.removeFromParent()
            }
            rect.texture = SKTexture(imageNamed: a)
        }
        switch n {
        case 1:
            notes.run(rightUp)
            notes.run(fadeOut)
            lights.run(SKAction.fadeOut(withDuration: 0.35))
            backg.run(SKAction.colorize(withColorBlendFactor: 0.05, duration: 0.42))
            sadtrick.run(fadeIn)
            patrick.run(SKAction.sequence([wait,fadeOut]))
        case 2:
            skeletrick.run(SKAction.fadeAlpha(to: 1, duration: 1))
            sadtrick.run(fadeOut)
            notes.run(fadeOut)
            notes.removeFromParent()
        case 3:
            sadtrick.texture = SKTexture(imageNamed: "Patrick.png")
            skeletrick.run(fadeOut)
            sadtrick.run(fadeIn)
            backg.run(SKAction.colorize(withColorBlendFactor: 0, duration: 1))
            self.GO(0.35)
            self.run(SKAction.sequence([
                wait,
                SKAction.run() {
                    self.GO(0.6)
                },
                ]))
        case 4:
            others.addChild(piano)
            skeletrick.removeFromParent()
            bigtrick.run(SKAction.sequence([
                wait,
                wait,
                SKAction.fadeAlpha(to: 0.35, duration: 3.5),
                wait,
                SKAction.fadeAlpha(to: 0.9, duration: 5)
                ]))
            bigtrick.run(SKAction.sequence([
                wait,
                wait,
                SKAction.moveTo(y: bigtrick.size.height / 2 + rect.position.y + 30, duration: 2.4)
                ]))
            n += 1
        default:
            ()
        }
        timeSecond = 0
        touchCount = 0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            touchCount += 1
            let location = touch.location(in: self)
            if back.contains(location) {
                let newScene = mainMenu(size: self.size)
                changeScene(newScene)
            } else if link.contains(location) {
                if let requestUrl = URL(string: "http://5lung.tk") {
                    UIApplication.shared.openURL(requestUrl)
                }
            }
            else if n >= 5 && rect.contains(location) {
                let newScene = GameScene(size: self.size)
                changeScene(newScene)
            } else {
                if touchCount == 1 && n < 4 {
                    n += 1
                    if timeSecond >= timeWait[n-1] {
                        endTouch(location)
                    } else {
                        self.run(SKAction.sequence([
                            SKAction.wait(forDuration: TimeInterval(timeWait[n-1] - timeSecond)),
                            SKAction.run() {
                                self.endTouch(location)
                            },
                            ]))
                    }
                }
            }
        }
    }
}
