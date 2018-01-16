import UIKit
import Vision

class ClassificationService {
    func classify(_ pixelBuffer: CVPixelBuffer, completion:((String)->())?) {
//        classify(usingModel: VGG16().model, pixelBuffer: pixelBuffer, completion: completion)
        classify(usingModel: Inceptionv3().model, pixelBuffer: pixelBuffer, completion: completion)
    }

    private func classify(usingModel model: MLModel, pixelBuffer: CVPixelBuffer, completion:((String)->())?) {
        DispatchQueue.global(qos: .background).async {
            do {
                let model = try VNCoreMLModel(for: model)
                let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                    DispatchQueue.main.async {
                        guard let results = request.results as? [VNClassificationObservation],
                        let result = results.first else { return }

                        let identifier = result.identifier.components(separatedBy: ",").first ?? result.identifier
                        completion?(identifier)
                    }
                })

                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
                try handler.perform([request])
            } catch {}
        }
    }
}
