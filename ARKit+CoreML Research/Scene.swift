import ARKit
import SpriteKit

class Scene: SKScene {
    private let classificationService = ClassificationService()
    var identifiers: [ARAnchor: String] = [:]

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let sceneView = self.view as? ARSKView,
        let currentFrame = sceneView.session.currentFrame else {
            return
        }

        if touches.count >= 2 {
            identifiers.forEach { (key, _) in
                sceneView.session.remove(anchor: key)
            }
            identifiers.removeAll()
            return
        }

        classificationService.classify(currentFrame.capturedImage) {[weak self] identifier in
            var translation = matrix_identity_float4x4
            let result = sceneView.hitTest(CGPoint(x: 0.5, y: 0.5), types: [.existingPlaneUsingExtent, .featurePoint]).first
            translation.columns.3.z = Float(-(result?.distance ?? 0.4))
            let transform = simd_mul(currentFrame.camera.transform, translation)
            let anchor = ARAnchor(transform: transform)
            self?.identifiers[anchor] = identifier
            sceneView.session.add(anchor: anchor)
        }
    }
}
