import UIKit
import AVFoundation

class PreviewView: UIView {
        
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else { fatalError() }
        return layer
    }
    
    var pointLayer: CAShapeLayer?
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer?.session
        }
        set {
            videoPreviewLayer?.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    func drawPoints(points: [CGPoint]) {
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        
        // comment out the following line to paint the screen :)
        pointLayer?.removeFromSuperlayer()
        
        let convertedPoints = points.map {
            videoPreviewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }

        let finalPath = CGMutablePath()
        convertedPoints.forEach { point in
            let path = UIBezierPath(ovalIn: CGRect(x: self.frame.width - point.x - 15, y: point.y - 15, width: 30, height: 30))
            finalPath.addPath(path.cgPath)
        }
        
        pointLayer = CAShapeLayer()
        pointLayer!.path = finalPath
        pointLayer!.strokeColor = UIColor.red.cgColor
        pointLayer!.fillColor = UIColor.red.cgColor
        videoPreviewLayer.addSublayer(pointLayer!)
    }
    
}
