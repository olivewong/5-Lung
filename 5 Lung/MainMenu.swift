import Foundation
import SpriteKit
import AVFoundation

var loadNumber: Int = 0
class mainMenu: SKScene {
    
    let patrick = SKSpriteNode(imageNamed: "singingpatrick.png")
    
    func changeScene(newScene: SKScene, transition: SKTransition) {
        newScene.scaleMode = scaleMode
        self.view?.presentScene(newScene, transition: transition)
    }
    
    override func didMoveToView(view: SKView) {
        
        loadNumber++
        
        checkMusic()
        
        let height = self.frame.size.height
        let width = self.frame.size.width

        self.addChild(bg(lights: true))
        
        var muspic = "Music"

        if !musicOn {
            muspic = "No Music"
        } else {
            if loadNumber == 1 {
                playBackgroundMusic()
            }
        }
        
        let q = Global.Button(texture: "q.png", name: "about", xpos: 0.75)
        self.addChild(q)
        
        let play = Global.Button(texture: "play.png", name: "play", xpos: 0.5)
        self.addChild(play)
        
        let music = Global.Button(texture: muspic, name: "music", xpos: 0.25)
        self.addChild(music)
        
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.46)
        patrick.size = CGSizeMake(height * 0.187, height * 0.45)
        patrick.zPosition = 5
        self.addChild(patrick)
        
        let title = SKSpriteNode(imageNamed: "Title.png")
        title.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.78 )
        title.size = title.texture!.size()
        title.zPosition = 5
        self.addChild(title)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodey = self.nodeAtPoint(location)
            if let myClass = nodey as? Global.Button {
                myClass.touchDown()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodey = self.nodeAtPoint(location)
            if let myClass = nodey as? Global.Button {
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
                }
            }
        }
    }
}