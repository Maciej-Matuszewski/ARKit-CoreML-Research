import UIKit
import ARKit
import SpriteKit

class ViewController: UIViewController {
    let sceneView = ARSKView(frame: UIScreen.main.bounds)
    let scene = Scene(size: UIScreen.main.bounds.size)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.presentScene(scene)
        sceneView.isMultipleTouchEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension ViewController: ARSKViewDelegate {
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard let identifier = scene.identifiers[anchor] else { return nil }
        let labelNode = SKLabelNode(text: identifier)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontName = UIFont.boldSystemFont(ofSize: 10).fontName
        labelNode.fontSize = 10
        labelNode.fontColor = .red
        return labelNode
    }
}
