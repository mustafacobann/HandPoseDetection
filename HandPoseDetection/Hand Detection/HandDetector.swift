import Foundation
import Vision

class HandDetector {
    
    let request = VNDetectHumanHandPoseRequest()
    var requestHandler: VNImageRequestHandler?
    var recognizedPoints: [VNRecognizedPoint]?
    
    func setRequestHandler(cmSampleBuffer: CMSampleBuffer) {
        requestHandler = VNImageRequestHandler(cmSampleBuffer: cmSampleBuffer, orientation: .up)
    }
    
    func getObservations() -> [CGPoint] {
        do {
            try requestHandler?.perform([request])
            if let observations = request.results {
                recognizedPoints = []
                try observations.forEach({ observation in
                    let allPoints = try observation.recognizedPoints(.all)
                    allPoints.forEach { (_, value) in
                        recognizedPoints?.append(value)
                    }
                })
                
                let CGPointObservations = recognizedPoints?.filter { $0.confidence > 0.7 }.map {
                    CGPoint(x: $0.location.x, y: $0.location.y)
                }
                
                return CGPointObservations ?? []
            }
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
}
