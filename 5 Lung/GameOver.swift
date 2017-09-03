import Foundation
import UIKit
import SpriteKit

class GameOver: SKScene {
    
    class overButton: SKSpriteNode {
        
        let screenSize = UIScreen.main.bounds
        init(txt: String, y: CGFloat) {
            let sizey: CGSize = scoreboardSize()
            let gap = screenSize.width * 0.035
            let width = ((sizey.width - gap) * 0.5)
            super.init(texture: SKTexture(imageNamed: txt), color: SKColor.red, size: CGSize(width: width, height: width * 0.3322))
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
    
    func changeScene(_ newScene: SKScene) {
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.reveal(with: .up, duration: 1.3)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    override func didMove(to view: SKView) {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let gap = width * 0.035
        
        self.addChild(bg(lights: true))
        
        let defaults = UserDefaults.standard
        
        if let highScore = defaults.string(forKey: "highScore") {
            if count > Int(highScore)! {
                defaults.set(count, forKey: "highScore")
                highLung = count
            } else {
                highLung = Int(highScore)
            }
        } else {
            highLung = count
            defaults.set(count, forKey: "highScore")
        }
        
        if let totalScore = defaults.string(forKey: "totalScore") {
            let newScore = Int(totalScore)! + count
            totalLung = newScore
            defaults.set(newScore, forKey: "totalScore")
        } else {
            totalLung = count
            defaults.set(count, forKey: "totalScore")
        }

        
        let title = SKSpriteNode(imageNamed:
            "Game Over.png")
        title.position = CGPoint(x: self.frame.size.width / 2, y: height * 0.75)
        if UIDevice.current.userInterfaceIdiom == .pad {
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
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.zPosition = 5
        highScoreLabel.fontSize = scoreboard.size.height * 0.23
        
        self.addChild(highScoreLabel)
        
        let scoreText = highScoreLabel.copy() as! SKLabelNode
        scoreText.text = "\(count)"
        scoreText.position.x = scoreboard.position.x - scoreboard.size.width * 0.235
        self.addChild(scoreText)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = (touch as! UITouch).location(in: self)
            let node = self.atPoint(location)
            
            if let button = node as? overButton {
                if button.name == "restart" {
                    let playAgain = GameScene(size: self.size)
                    changeScene(playAgain)
                    
                } else if button.name == "menu" {
                    let menu = mainMenu(size: self.size)
                    changeScene(menu)
                }
            }
        }
        
    }
}
