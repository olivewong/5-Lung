

import SpriteKit
import CoreMotion
import AudioToolbox

var count = 0
var timer = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    let bg = SKSpriteNode(imageNamed: "No Lights.png")
    let patrick = SKSpriteNode(imageNamed: "Patrick.png")
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
    var pianoPool: [SKSpriteNode] = []
    
    func determineXPos() -> CGFloat {
        var pos = CGFloat(arc4random_uniform(100))
        if pos > 70 {
            pos -= (CGFloat(arc4random_uniform(35)) + 9)
        } else if pos < 30 {
            pos += (CGFloat(arc4random_uniform(34)) + 9)
        }
        pos = pos/100
        return pos
    }
    func determineHowSpinny() -> CGFloat {
        var angular_velocity = CGFloat(arc4random_uniform(40)) / 10
        if arc4random_uniform(2) == 1 {
            angular_velocity = angular_velocity * -1
        }
        return angular_velocity
    }
    func lungSize() -> CGSize {
        let screenSize = UIScreen.main.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            return(CGSize(width: CGFloat(screenSize.width * 0.1), height: CGFloat(screenSize.width * 0.138)))
        } else {
            return(CGSize(width: CGFloat(screenSize.width * 0.13), height: CGFloat(screenSize.width * 0.18)))
        }
    }
    
    override func didMove(to view: SKView) {
        
        if musicOn {
            changeMusic(self)
        }
        
        motionManager.startAccelerometerUpdates()
        
        count = 0
        let screenSize = UIScreen.main.bounds
        
        class Lung: SKSpriteNode {
            
            let screenSize = UIScreen.main.bounds
            init() {
                super.init(texture: SKTexture(imageNamed: "Lung.png"), color: SKColor.blue, size: GameScene().lungSize())
                self.name = name
                self.position = CGPoint(x: self.frame.size.width * GameScene().xPos(), y: self.frame.size.height + 80)
                self.isHidden = true
                self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
                self.physicsBody?.affectedByGravity = false
                self.physicsBody?.isDynamic = true
                self.name = "lung"
                self.zPosition = 5
                self.position = CGPoint(x: self.frame.size.width * GameScene().xPos(), y: self.frame.size.height + 80)
                self.physicsBody?.usesPreciseCollisionDetection = true
                self.physicsBody?.allowsRotation = true
                self.physicsBody?.angularVelocity = GameScene().determineHowSpinny()
                self.physicsBody?.categoryBitMask = physicsCategory.lung
                self.physicsBody?.collisionBitMask = physicsCategory.None
                self.physicsBody?.contactTestBitMask = physicsCategory.Trick | physicsCategory.Border
            }
            required init(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        let lungHolder = SKNode()
        self.addChild(lungHolder)
        var lungs: [Lung] = []
        

        var wait = SKAction.wait(forDuration: 1.6)
        var fallingLungsAction = SKAction.run {
            timer += 1
            if lungs.count > 1 {
                lungs.remove(at: 0)
            }
            func positionLung() {
                let lung: Lung = Lung()
                lung.position.x = self.frame.size.width * CGFloat(arc4random_uniform(76) + 12) / 100
                lung.position.y = self.frame.size.height + 100
                lung.isHidden = false
                lung.physicsBody?.affectedByGravity = true
                lungs.append(lung)
                lungHolder.addChild(lung)
            }
            positionLung()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([wait, fallingLungsAction])))
        
        
        func addLung(_ lung: Lung) {
            if arc4random_uniform(2) == 1{
                lung.xScale = -1.0;
            }
            lungPool.append(lung)
            self.addChild(lung)
        }
        addLung(Lung())
        
        addLung(Lung())

        backgroundColor = SKColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.32)
        } else {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.97)
        }
        physicsWorld.contactDelegate = self;

        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        bg.size = self.frame.size
        bg.zPosition = -1
        bg.position = CGPoint(x: width / 2, y: self.frame.size.height / 2)
        
        self.addChild(bg)
        
        var patWidth = height * 0.1
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            patWidth = height * 0.115
        }
        patrick.size = CGSize(width: patWidth, height: patWidth * 2.38)
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: (patrick.size.height / CGFloat(2) + 1.5))
        patrick.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: patWidth * 0.9, height: patWidth * 0.9))
        patrick.physicsBody?.friction = 0
        patrick.physicsBody?.isDynamic = true
        patrick.physicsBody?.allowsRotation = false
        patrick.physicsBody?.affectedByGravity = false
        patrick.physicsBody?.categoryBitMask = physicsCategory.Trick
        patrick.physicsBody?.collisionBitMask = physicsCategory.Border
        patrick.physicsBody?.contactTestBitMask = physicsCategory.lung | physicsCategory.Border
        patrick.physicsBody?.mass = 0.03
        patrick.physicsBody?.restitution = 0.05
        self.addChild(patrick)
        
        var muspic = "Music"
        if !musicOn {
            muspic = "No Music"
        }

        let left = SKShapeNode(rectOf: CGSize(width: 1, height: height))
        left.position = CGPoint(x: 0, y: height / 2 + 7)
        left.alpha = 0
        left.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: height))
        left.physicsBody?.affectedByGravity = false
        left.physicsBody?.isDynamic = false
        left.physicsBody?.categoryBitMask = physicsCategory.Border
        left.physicsBody?.contactTestBitMask = physicsCategory.None
        left.physicsBody?.collisionBitMask = physicsCategory.Trick
        self.addChild(left)
        
        let right = left.copy() as! SKShapeNode
        right.position.x = width + 2
        self.addChild(right)
        
        scoreBG.size = CGSize(width: 155, height: 56)
        scoreBG.anchorPoint = CGPoint(x: 0, y: 1)
        scoreBG.position = CGPoint(x: 15, y: self.frame.size.height - 15)
        scoreBG.zPosition = 30
        self.addChild(scoreBG)

        score.position = CGPoint(x: scoreBG.size.width * 0.833 + 10, y: self.frame.size.height - 41)
        if UIScreen.main.scale == 1.0 {
            score.position = CGPoint(x: scoreBG.size.width * 0.833 + 14, y: self.frame.size.height - 40)
        }
        score.fontSize = 25
        score.text = "\(count)"
        score.verticalAlignmentMode = .center
        score.zPosition = 105
        self.addChild(score)
        
        let stage = SKShapeNode(rectOf: CGSize(width: width + 10, height: height * 0.018))
        stage.fillColor = SKColor(red: 64/255, green: 192/255, blue: 212/255, alpha: 0.4)
        stage.position = CGPoint(x: width / 2, y: 0)
        stage.lineWidth = 0
        stage.zPosition = 0
        self.addChild(stage)
    }
    
    
    func returnLung(_ lung: SKNode) {
        lung.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run() {
                    lung.isHidden = true
                    lung.physicsBody?.affectedByGravity = false
                    lung.position.y = UIScreen.main.bounds.height
                }
                ]))
    }
    func glow() {
        let glowy = SKAction.colorize(with: UIColor(red: 1.0, green: 217/255, blue: 226/255, alpha: 1.0), colorBlendFactor: CGFloat(0.25), duration: 0.2)
        let gloww = SKAction.sequence([
            glowy,
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.2),
            ])
        if patrick.colorBlendFactor < 0.01 {
            patrick.run(gloww)
        }
    }
    func faster() {
        // Make the game harder (objects fall faster) as the user progresses
        switch count {
        case 5:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.36)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
            }
        case 15:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.05)
            }
        case 30:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.75)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.2)
            }
        case 62:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.4)
            }
        case 100:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.3)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.85)
            }
        case 150:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.7)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
            }
        case 210:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.3)
            }
        case 350:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.2)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.5)
            }
        case 500:
            if UIDevice.current.userInterfaceIdiom == .pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.6)
            } else {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -2.9)
            }
        default:
            ()
        }
    }

    let shrink = SKAction.scale(by: 0.5, duration: 0.1)
    let lungSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
    let wallSound = SKAction.playSoundFileNamed("zap.wav", waitForCompletion: false)
    func didBegin(_ contact: SKPhysicsContact) {
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
                if !contactBody2.node!.isHidden {
                    run(lungSound)
                    count += 1
                    faster()
                    if count > 99 {
                        score.fontSize = 20.5
                    }
                    glow()
                    returnLung(contactBody2.node!)
                }
            case "keys":
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                contactBody1.node!.physicsBody?.affectedByGravity = true
                let newScene = GameOver(size: self.size)
                newScene.scaleMode = scaleMode
                let reveal = SKTransition.reveal(with: .down, duration: 1.3)
                self.view?.presentScene(newScene, transition: reveal)
            default:
                ()
            }
        } else if (contactBody1.categoryBitMask == 1) && (contactBody2.categoryBitMask == 4) {
            run(wallSound)
        }
    }
    
    var findLung = false
    var findPiano = false

    
    func moveLung(_ lung: SKSpriteNode) {
        lung.position.y = self.frame.size.height + CGFloat(arc4random_uniform(5) * 10 + 20)
        lung.physicsBody?.angularVelocity = determineHowSpinny()
        lung.physicsBody?.velocity = CGVector(dx: 0, dy: 0);
        lung.isHidden = false
        lung.position.x = self.frame.size.width * xPos()
        lung.physicsBody?.affectedByGravity = true
    }
    
    
    func movePatrick(_ currentTime: CFTimeInterval) {
        if let data = motionManager.accelerometerData {
            if (fabs(data.acceleration.x) > 0.17) {
                /* iphone
                patrick.physicsBody!.applyImpulse(CGVectorMake(0.5 * CGFloat(data.acceleration.x), 0))
                patrick.physicsBody!.applyForce(CGVectorMake(60 * CGFloat(data.acceleration.x), 0))
                */
                
                /*
                patrick.physicsBody!.applyImpulse(CGVectorMake(0.5 * CGFloat(data.acceleration.x), 0))
                patrick.physicsBody!.applyForce(CGVectorMake(self.frame.size.width * 0.16 * CGFloat(data.acceleration.x), 0))
                */
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    patrick.physicsBody!.applyImpulse(CGVector(dx: self.frame.size.width * 0.0006 * CGFloat(data.acceleration.x), dy: 0))
                    patrick.physicsBody!.applyForce(CGVector(dx: self.frame.size.width * 0.15 * CGFloat(data.acceleration.x), dy: 0))
                } else {
                    patrick.physicsBody!.applyImpulse(CGVector(dx: self.frame.size.width * 0.001 * CGFloat(data.acceleration.x), dy: 0))
                    patrick.physicsBody!.applyForce(CGVector(dx: self.frame.size.width * 0.125 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
        }
    }
    
    func positioner(follow: Bool) -> CGFloat {
        var n: CGFloat = (CGFloat(arc4random_uniform(60)) + 70)
        n = n/200
        if follow && Int(arc4random_uniform(2)) == 1 {
            n = CGFloat(patrick.position.x)
            if Int(arc4random_uniform(2)) == 1 {
                let p: CGFloat = CGFloat(arc4random_uniform(20))
                n += CGFloat(p)
            }
        } else {
            n = self.frame.size.width * n
        }
        return(CGFloat(n))
    }
    
    func createPianoNode() {
        let piano = SKSpriteNode(imageNamed: "Piano.png")
        let pianoWidth = self.frame.size.width * 0.23
        //.689
        piano.size = CGSize(width: pianoWidth, height: pianoWidth * 0.693)
        piano.position.y = self.frame.size.height + 90
        piano.position.x = positioner(follow: true)
        piano.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pianoWidth, height: piano.size.height * 0.66), center: CGPoint(x: 0.5, y: 0.83))
        piano.name = "keys"
        piano.physicsBody?.usesPreciseCollisionDetection = true
        piano.physicsBody?.restitution = 0
        piano.physicsBody?.friction = 1
        piano.physicsBody?.categoryBitMask = physicsCategory.lung
        piano.physicsBody?.collisionBitMask = physicsCategory.Border | physicsCategory.Trick
        piano.physicsBody?.contactTestBitMask = physicsCategory.Trick
        piano.physicsBody?.affectedByGravity = true
        piano.zPosition = 29
        self.addChild(piano)
        pianoPool.append(piano)
    }
    
    func pianoSeparated() -> Bool {
        // Fixes issue where too many pianos are on the screen at once
        var enoughSpace: Bool = true
        for piano in pianoPool {
            if piano.position.y > self.frame.size.height * 0.85 {
                enoughSpace = false
            }
        }
        return enoughSpace
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for lung in lungPool {
            if lung.position.y < 50 {
                returnLung(lung)
            }
        }
        
        let i = 0
        for piano in pianoPool {
            if piano.position.y < -200 {
                piano.removeFromParent()
                pianoPool.remove(at: i)
            }
        }
        
        score.text = "\(count)"
        
        movePatrick(currentTime)
        
        // Determine whether to spawn a new piano or lung
        let diceRoll = Int(arc4random_uniform(100))
        if diceRoll % 2 == 0 {
            switch diceRoll {
                case 1...3:
                    findLung = true
                    while findLung {
                        for i in 0...(lungPool.count-1) {
                            if lungPool[i].isHidden {
                                moveLung(lungPool[i])
                                findLung = false
                                break
                            }
                        }
                        findLung = false
                    }
                case 6:
                    if pianoPool.count < 3 && timer > 2 && pianoSeparated() {
                        createPianoNode()
                    }
                default:
                    ()
            }
        }
    }
}

