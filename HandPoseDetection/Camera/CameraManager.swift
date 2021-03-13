import UIKit
import AVFoundation
import Vision

class CameraManager: NSObject {
        
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "AVSession Queue")
    let sampleBufferQueue = DispatchQueue(label: "AVOutput Sample Buffer Queue")
    var authorizationStatus: AuthorizationStatus?
    var previewView: PreviewView?
    let handDetector = HandDetector()
    
    init(isFront: Bool) {
        super.init()
        checkAuthorization()
        sessionQueue.async {
            self.configureSession(isFront: isFront)
        }
    }
    
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            authorizationStatus = .authorized
        case .notDetermined, .denied:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                if !isGranted {
                    self.authorizationStatus = .unauthorized
                }
                self.sessionQueue.resume()
            }
        default:
            authorizationStatus = .authorized
        }
    }
    
    func configureSession(isFront: Bool) {
        guard authorizationStatus == .authorized else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: isFront ? .front : .back).devices.first else { fatalError("No camera found :(") }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device)
            session.addInput(deviceInput)
            
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
            session.addOutput(videoDataOutput)
            
            session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func startSession() {
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
        
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        handDetector.setRequestHandler(cmSampleBuffer: sampleBuffer)
        let points = handDetector.getObservations()
        DispatchQueue.main.async {
            self.previewView?.drawPoints(points: points)
        }
    }
    
}
