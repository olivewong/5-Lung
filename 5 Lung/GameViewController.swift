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
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        UIApplication.shared.isIdleTimerDisabled = true
        try! sickLungTunez()
    }
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
}
