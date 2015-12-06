import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        //let value = UIInterfaceOrientation.LandscapeLeft.rawValue
       // UIDevice.currentDevice().setValue(value, forKey: "orientation")
        super.viewDidLoad()
        prepareBackgroundMusic("menu.mp3")
        let scene = mainMenu(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        UIApplication.sharedApplication().idleTimerDisabled = true
        try! sickLungTunez()
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
}