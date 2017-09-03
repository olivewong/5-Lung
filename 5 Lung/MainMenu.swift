import Foundation
import SpriteKit
import AVFoundation

var loadNumber: Int = 0
class mainMenu: SKScene {
    
    let patrick = SKSpriteNode(imageNamed: "singingpatrick.png")
    
    func changeScene(_ newScene: SKScene, transition: SKTransition) {
        newScene.scaleMode = scaleMode
        self.view?.presentScene(newScene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        
        loadNumber += 1
        
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
        patrick.size = CGSize(width: height * 0.187, height: height * 0.45)
        patrick.zPosition = 5
        self.addChild(patrick)
        
        let title = SKSpriteNode(imageNamed: "Title.png")
        title.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.78 )
        title.size = title.texture!.size()
        title.zPosition = 5
        self.addChild(title)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if let myClass = node as? Global.Button {
                myClass.touchDown()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let nodey = self.atPoint(location)
            if let myClass = nodey as? Global.Button {
                myClass.touchUp()
            }
            if let name = nodey.name {
                if name == "play" {
                    let newScene = GameScene(size: self.size)
                    changeScene(newScene, transition: SKTransition.reveal(with: .up, duration: 1.5))
                } else if name == "about" {
                    patrick.run(SKAction.move(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 + 15), duration: 0.6))
                    let newScene = about(size: self.size)
                    self.changeScene(newScene, transition: SKTransition.crossFade(withDuration: 1.5))
                }
            }
        }
    }
}
