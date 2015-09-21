

import SpriteKit
import CoreMotion
import AudioToolbox

var count = 0
var timer = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let motionManager: CMMotionManager = CMMotionManager()
    
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
    var pianoPool: [SKSpriteNode] = []
    
    func xPos() -> CGFloat {
        var pos = CGFloat(arc4random_uniform(100))
        if pos > 70 {
            pos -= (CGFloat(arc4random_uniform(35)) + 9)
        } else if pos < 30 {
            pos += (CGFloat(arc4random_uniform(34)) + 9)
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
        
        if musicOn {
            changeMusic(self)
        }
        
        motionManager.startAccelerometerUpdates()
        
        count = 0
        let screenSize = UIScreen.mainScreen().bounds
        
        class Lung: SKSpriteNode {
            
            let screenSize = UIScreen.mainScreen().bounds
            init() {
                super.init(texture: SKTexture(imageNamed: "Lung"), color: SKColor.blueColor(), size: GameScene().lungSize())
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
        
        let lungz = SKNode()
        self.addChild(lungz)
        var lunPool: [Lung] = []
        

        var wait = SKAction.waitForDuration(1.6)
        var run = SKAction.runBlock {
            timer++
            if lunPool.count > 1 {
                lunPool.removeAtIndex(0)
            }
            func lungg() {
                var lun: Lung = Lung()
                lun.position.x = self.frame.size.width * CGFloat(arc4random_uniform(76) + 12) / 100
                lun.position.y = self.frame.size.height + 100
                lun.hidden = false
                lun.physicsBody?.affectedByGravity = true
                lunPool.append(lun)
                lungz.addChild(lun)
            }
            lungg()
        }
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
        
        
        func addLung(lung: Lung) {
            if arc4random_uniform(2) == 1{
                lung.xScale = -1.0;
            }
            lungPool.append(lung)
            self.addChild(lung)
        }
        addLung(Lung())
        
        addLung(Lung())

        backgroundColor = SKColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.physicsWorld.gravity = CGVectorMake(0, -1.32)
        } else {
            self.physicsWorld.gravity = CGVectorMake(0, -0.97)
        }
        physicsWorld.contactDelegate = self;

        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        bg.size = self.frame.size
        bg.zPosition = -1
        bg.position = CGPointMake(width / 2, self.frame.size.height / 2)
        
        self.addChild(bg)
        
        var patWidth = height * 0.1
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            patWidth = height * 0.115
        }
        patrick.size = CGSize(width: patWidth, height: patWidth * 2.38)
        patrick.position = CGPoint(x: self.frame.size.width / 2, y: (patrick.size.height / CGFloat(2) + 1.5))
        patrick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: patWidth * 0.9, height: patWidth * 0.9))
        patrick.physicsBody?.friction = 0
        patrick.physicsBody?.dynamic = true
        patrick.physicsBody?.allowsRotation = false
        patrick.physicsBody?.affectedByGravity = false
        patrick.physicsBody?.categoryBitMask = physicsCategory.Trick
        patrick.physicsBody?.collisionBitMask = physicsCategory.Border
        patrick.physicsBody?.contactTestBitMask = physicsCategory.lung | physicsCategory.Border
        patrick.physicsBody?.mass = 0.03
        patrick.physicsBody?.restitution = 0.1
        patrick.name = "mr. stump"
        self.addChild(patrick)
        
        var muspic = "Music"
        if !musicOn {
            muspic = "No Music"
        }

        let left = SKShapeNode(rectOfSize: CGSize(width: 1, height: height))
        left.position = CGPoint(x: 0, y: height / 2 + 7)
        left.alpha = 0
        left.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1, height: height))
        left.physicsBody?.affectedByGravity = false
        left.physicsBody?.dynamic = false
        left.physicsBody?.categoryBitMask = physicsCategory.Border
        left.physicsBody?.contactTestBitMask = physicsCategory.None
        left.physicsBody?.collisionBitMask = physicsCategory.Trick
        self.addChild(left)
        
        var right = left.copy() as! SKShapeNode
        right.position.x = width
        self.addChild(right)
        
        scoreBG.size = CGSizeMake(155, 56)
        scoreBG.anchorPoint = CGPointMake(0, 1)
        scoreBG.position = CGPoint(x: 15, y: self.frame.size.height - 15)
        scoreBG.zPosition = 30
        self.addChild(scoreBG)

        score.position = CGPoint(x: scoreBG.size.width * 0.833 + 10, y: self.frame.size.height - 41)
        if UIScreen.mainScreen().scale == 1.0 {
            score.position = CGPoint(x: scoreBG.size.width * 0.833 + 14, y: self.frame.size.height - 40)
        }
        score.fontSize = 25
        score.text = "\(count)"
        score.verticalAlignmentMode = .Center
        score.zPosition = 105
        self.addChild(score)
        
        let stage = SKShapeNode(rectOfSize: CGSize(width: width + 10, height: height * 0.018))
        stage.fillColor = SKColor(red: 64/255, green: 192/255, blue: 212/255, alpha: 0.4)
        stage.position = CGPoint(x: width / 2, y: 0)
        stage.lineWidth = 0
        stage.zPosition = 0
        self.addChild(stage)
    }
    
    
    func returnLung(lung: SKNode) {
        lung.runAction(
            SKAction.sequence([
                SKAction.waitForDuration(0.1),
                SKAction.runBlock() {
                    lung.hidden = true
                    lung.physicsBody?.affectedByGravity = false
                    lung.position.y = UIScreen.mainScreen().bounds.height
                }
                ]))
    }
    func glow() {
        let glowy = SKAction.colorizeWithColor(UIColor(red: 1.0, green: 217/255, blue: 226/255, alpha: 1.0), colorBlendFactor: CGFloat(0.25), duration: 0.2)
        let gloww = SKAction.sequence([
            glowy,
            SKAction.waitForDuration(0.01),
            SKAction.colorizeWithColorBlendFactor(0, duration: 0.2),
            ])
        if patrick.colorBlendFactor < 0.02 {
            patrick.runAction(gloww)
        }
    }
    func faster() {
        switch count {
        case 5:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -1.36)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -1.0)
            }
        case 15:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -1.5)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -1.05)
            }
        case 30:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -1.75)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -1.2)
            }
        case 62:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -2)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -1.4)
            }
        case 100:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -2.3)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -1.85)
            }
        case 150:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -2.7)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -2)
            }
        case 210:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -3)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -2.3)
            }
        case 350:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -3.2)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -2.5)
            }
        case 500:
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                //originally -1.35
                self.physicsWorld.gravity = CGVectorMake(0, -3.6)
            } else {
                self.physicsWorld.gravity = CGVectorMake(0, -2.9)
            }
        default:
            ()
        }
    }

    let shrink = SKAction.scaleBy(0.5, duration: 0.1)
    let lungSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
    let wallSound = SKAction.playSoundFileNamed("zap.wav", waitForCompletion: false)
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
                if !contactBody2.node!.hidden {
                    runAction(lungSound)
                    count++
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
                let reveal = SKTransition.revealWithDirection(.Down, duration: 1.3)
                self.view?.presentScene(newScene, transition: reveal)
            default:
                ()
            }
        } else if (contactBody1.categoryBitMask == 1) && (contactBody2.categoryBitMask == 4) {
            runAction(wallSound)
        }
    }
    
    var findLung = false
    var findPiano = false

    
    func moveLung(lung: SKSpriteNode) {
        lung.position.y = self.frame.size.height + CGFloat(arc4random_uniform(5) * 10 + 20)
        lung.physicsBody?.angularVelocity = spinny()
        lung.physicsBody?.velocity = CGVectorMake(0, 0);
        lung.hidden = false
        lung.position.x = self.frame.size.width * xPos()
        lung.physicsBody?.affectedByGravity = true
    }
    
    
    func movePatrick(currentTime: CFTimeInterval) {
        if let data = motionManager.accelerometerData {
            if (fabs(data.acceleration.x) > 0.2) {
                /* iphone
                patrick.physicsBody!.applyImpulse(CGVectorMake(0.5 * CGFloat(data.acceleration.x), 0))
                patrick.physicsBody!.applyForce(CGVectorMake(60 * CGFloat(data.acceleration.x), 0))
                */
                
                /*
                patrick.physicsBody!.applyImpulse(CGVectorMake(0.5 * CGFloat(data.acceleration.x), 0))
                patrick.physicsBody!.applyForce(CGVectorMake(self.frame.size.width * 0.16 * CGFloat(data.acceleration.x), 0))
                */
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    patrick.physicsBody!.applyImpulse(CGVectorMake(self.frame.size.width * 0.0005 * CGFloat(data.acceleration.x), 0))
                    patrick.physicsBody!.applyForce(CGVectorMake(self.frame.size.width * 0.1 * CGFloat(data.acceleration.x), 0))
                } else {
                    patrick.physicsBody!.applyImpulse(CGVectorMake(self.frame.size.width * 0.001 * CGFloat(data.acceleration.x), 0))
                    patrick.physicsBody!.applyForce(CGVectorMake(self.frame.size.width * 0.155 * CGFloat(data.acceleration.x), 0))
                }
                
                // original patrick.physicsBody!.applyForce(CGVectorMake(110 * CGFloat(data.acceleration.x), 0))
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
        }
    }
    
    func positioner(follow follow: Bool) -> CGFloat {
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
        let piano = SKSpriteNode(imageNamed: "Piano")
        let pianoWidth = self.frame.size.width * 0.23
        //.689
        piano.size = CGSize(width: pianoWidth, height: pianoWidth * 0.693)
        piano.position.y = self.frame.size.height + 90
        piano.position.x = positioner(follow: true)
        piano.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: pianoWidth, height: piano.size.height * 0.66), center: CGPoint(x: 0.5, y: 0.83))
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
        var poo: Bool = true
        for piano in pianoPool {
            if piano.position.y > self.frame.size.height * 0.85 {
                poo = false
            }
        }
        return poo
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        for lung in lungPool {
            if lung.position.y < 50 {
                returnLung(lung)
            }
        }
        
        let i = 0
        for piano in pianoPool {
            if piano.position.y < -200 {
                piano.removeFromParent()
                pianoPool.removeAtIndex(i)
            }
        }
        
        score.text = "\(count)"
        
        movePatrick(currentTime)
        let thing = Int(arc4random_uniform(100))
        if thing % 2 == 0 {
            switch thing {
                case 1...3:
                    findLung = true
                    while findLung {
                        for i in 0...(lungPool.count-1) {
                            if lungPool[i].hidden {
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

