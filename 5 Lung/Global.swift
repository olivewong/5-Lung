

import Foundation
import SpriteKit
import AVFoundation

var musicOn = false
var soundOn = false
var musicStarted: Bool = false

var backgroundMusicPlayer: AVAudioPlayer!
var gameMusic: AVAudioPlayer!

let blank = SKNode()


func scoreboardSize() -> CGSize {
    let screenSize = UIScreen.main.bounds
    var size: CGSize = CGSize(width: screenSize.width * 0.85, height: screenSize.width * 0.431)
    if UIDevice.current.userInterfaceIdiom == .pad {
        size = CGSize(width: screenSize.width * 0.75, height: screenSize.width * 0.38)
    }
    return size
}

func bg(lights: Bool) -> SKSpriteNode {
    let screenSize = UIScreen.main.bounds
    let texture = "Lights.png"
    if !lights {
        let texture = "No Lights.png"
    }
    let background: SKSpriteNode = SKSpriteNode(imageNamed: texture)
    background.size = CGSize(width: screenSize.width, height: screenSize.height)
    background.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    background.zPosition = -2
    background.blendMode = .replace
    return background
}

func checkMusic() {
    let defaults = UserDefaults.standard
    if let sound = defaults.string(forKey: "music") {
        if sound == "true" {
            musicOn = true
        } else {
            musicOn = false
        }
    } else {
        defaults.set("true", forKey: "sound")
        musicOn = true
    }
}

func prepareBackgroundMusic(_ filename: String) {
    let url = Bundle.main.url(
        forResource: filename, withExtension: nil)
    if (url == nil) {
        return
    }
    var error: NSError? = nil
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
    } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
    }
    if backgroundMusicPlayer == nil {
        return
    }
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
}
func playBackgroundMusic() {
    musicStarted = true
    if musicOn {
        backgroundMusicPlayer.play()
    }
}

public func pauseBackgroundMusic() {
    if let player = backgroundMusicPlayer {
        if player.isPlaying {
            player.pause()
        }
    }
}

func resumeBackgroundMusic() {
    if let player = backgroundMusicPlayer {
        if !player.isPlaying {
            player.play()
        }
    }
}

func toggleSound() {
    let defaults = UserDefaults.standard
    if let sound = defaults.string(forKey: "sound") {
        if sound == "false" {
            defaults.set("true", forKey: "sound")
            soundOn = true
        } else {
            defaults.set("false", forKey: "sound")
            soundOn = false
        }
    } else {
        defaults.set("false", forKey: "sound")
        soundOn = false
    }
}


let url = Bundle.main.url(
    forResource: "lungtheme.mp3", withExtension: nil)
/*

init() {
    do {
        try gameMusic = AVAudioPlayer(contentsOfURL: url)
        //Handle the error
    } catch {
        print("oops")
    }
    
}
*/

func sickLungTunez() throws {
    gameMusic = try AVAudioPlayer(contentsOf: url!)
}

//var error: NSError? = nil
//let gameMusic = AVAudioPlayer(contentsOfURL: url, error: &error)
var gameMusicPlaying: Bool = false

func changeMusic(_ node: SKScene) {
    gameMusic.prepareToPlay()
    gameMusicPlaying = true
    gameMusic.numberOfLoops = -1
    
    func gO() {
        backgroundMusicPlayer.stop()
        gameMusic.play()
    }
    let time = backgroundMusicPlayer.currentTime
    let remainding: TimeInterval = 8 - (time.truncatingRemainder(dividingBy: 8)) - 1.21
    let wait = SKAction.wait(forDuration: remainding)
    let seq = SKAction.sequence([
        wait,
        SKAction.run() {
            gO()
        }
        ])
    node.run(seq)
}
func toggleMusic() {
    let defaults = UserDefaults.standard
    func stopMusic() {
        defaults.set("false", forKey: "music")
        musicOn = false
        pauseBackgroundMusic()
        gameMusicPlaying = false
        gameMusic.pause()
    }
    if let music = defaults.string(forKey: "music") {
        if music == "false" {
            defaults.set("true", forKey: "music")
            musicOn = true
            if musicStarted == false {
                playBackgroundMusic()
            } else {
                resumeBackgroundMusic()
            }
        } else {
            stopMusic()
        }
    } else {
        stopMusic()
    }
}


open class Global {
    class Button: SKSpriteNode {
        let screenSize = UIScreen.main.bounds
        init(texture: String, name: String, xpos: CGFloat) {
            let texture = SKTexture(imageNamed: texture)
            super.init(texture: texture, color: SKColor.red, size: CGSize(width: CGFloat(screenSize.height * 0.11), height: CGFloat(screenSize.height * 0.11)))
            self.name = name
            self.position.y = screenSize.height * 0.134
            self.position.x = screenSize.width * xpos
        }
        func touchDown() {
            self.position.y -= 4
            if self.name == "music" {
                toggleMusic()
                if musicOn {
                    self.texture = SKTexture(imageNamed: "Music.png")
                } else {
                    self.texture = SKTexture(imageNamed: "No Music.png")
                }
            }
        }
        func touchUp() {
            self.position.y += 4
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


