//
//  Global.swift
//  5 Lung
//
//  Created by 😎 on 8/4/15.
//  Copyright (c) 2015 neuky. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

var musicOn = false
var soundOn = false
var musicStarted: Bool = false

var backgroundMusicPlayer: AVAudioPlayer!

let blank = SKNode()


func scoreboardSize() -> CGSize {
    let screenSize = UIScreen.mainScreen().bounds
    var size: CGSize = CGSize(width: screenSize.width * 0.85, height: screenSize.width * 0.431)
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        size = CGSize(width: screenSize.width * 0.75, height: screenSize.width * 0.38)
    }
    return size
}

func bg(lights lights: Bool) -> SKSpriteNode {
    let screenSize = UIScreen.mainScreen().bounds
    var texture = "Lights"
    if !lights {
        var texture = "No Lights"
    }
    let background: SKSpriteNode = SKSpriteNode(imageNamed: texture)
    background.size = CGSize(width: screenSize.width, height: screenSize.height)
    background.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    background.zPosition = -2
    background.blendMode = .Replace
    return background
}

func checkMusic() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let sound = defaults.stringForKey("music") {
        if sound == "true" {
            musicOn = true
        } else {
            musicOn = false
        }
    } else {
        defaults.setObject("true", forKey: "sound")
        musicOn = true
    }
}

func prepareBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        return
    }
    var error: NSError? = nil
    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
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
        if player.playing {
            player.pause()
        }
    }
}

func resumeBackgroundMusic() {
    if let player = backgroundMusicPlayer {
        if !player.playing {
            player.play()
        }
    }
}

func toggleSound() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let sound = defaults.stringForKey("sound") {
        if sound == "false" {
            defaults.setObject("true", forKey: "sound")
            soundOn = true
        } else {
            defaults.setObject("false", forKey: "sound")
            soundOn = false
        }
    } else {
        defaults.setObject("false", forKey: "sound")
        soundOn = false
    }
}


let url = NSBundle.mainBundle().URLForResource(
    "lungtheme.mp3", withExtension: nil)
var error: NSError? = nil
let gameMusic = AVAudioPlayer(contentsOfURL: url, error: &error)
var gameMusicPlaying: Bool = false

func changeMusic(node: SKScene) {
    gameMusic.prepareToPlay()
    gameMusicPlaying = true
    gameMusic.numberOfLoops = -1
    
    func gO() {
        backgroundMusicPlayer.stop()
        gameMusic.play()
    }
    let time = backgroundMusicPlayer.currentTime
    let remainding: NSTimeInterval = 8 - (time % 8) - 1.21
    let wait = SKAction.waitForDuration(remainding)
    let seq = SKAction.sequence([
        wait,
        SKAction.runBlock() {
            gO()
        }
        ])
    node.runAction(seq)
}
func toggleMusic() {
    let defaults = NSUserDefaults.standardUserDefaults()
    func stopMusic() {
        defaults.setObject("false", forKey: "music")
        musicOn = false
        pauseBackgroundMusic()
        gameMusicPlaying = false
        gameMusic.pause()
    }
    if let music = defaults.stringForKey("music") {
        if music == "false" {
            defaults.setObject("true", forKey: "music")
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


public class Global {
    class Button: SKSpriteNode {
        let screenSize = UIScreen.mainScreen().bounds
        init(texture: String, name: String, xpos: CGFloat) {
            let texture = SKTexture(imageNamed: texture)
            super.init(texture: texture, color: SKColor.redColor(), size: CGSizeMake(CGFloat(screenSize.height * 0.11), CGFloat(screenSize.height * 0.11)))
            self.name = name
            self.position.y = screenSize.height * 0.134
            self.position.x = screenSize.width * xpos
        }
        func touchDown() {
            self.position.y -= 4
            if self.name == "music" {
                toggleMusic()
                if musicOn {
                    self.texture = SKTexture(imageNamed: "Music")
                } else {
                    self.texture = SKTexture(imageNamed: "No Music")
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
    

