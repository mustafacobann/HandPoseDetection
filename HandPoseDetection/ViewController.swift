import UIKit

class ViewController: UIViewController {

    @IBOutlet var previewView: PreviewView!
    let cameraManager = CameraManager(isFront: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraManager.previewView = previewView
        previewView.session = cameraManager.session
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraManager.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraManager.stopSession()
    }

}

