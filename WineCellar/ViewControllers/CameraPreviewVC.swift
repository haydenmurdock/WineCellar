//
//  CameraPreviewVC.swift
//  WineCellar
//
//  Created by Hayden Murdock on 3/18/19.
//  Copyright © 2019 Hayden Murdock. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewVC: UIViewController {
    
    
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let imagePicker = UIImagePickerController()
    
    var wineImage: UIImage?{
        didSet{
            print("Image has been saved")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraPreviewLayer?.frame = cameraView.layer.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
    }
    
    
    @IBAction func snapPhotoButtonTapped(_ sender: UIButton) {
        
        let settings = AVCapturePhotoSettings()
        
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 20,
                             kCVPixelBufferHeightKey as String: 20]
        settings.previewPhotoFormat = previewFormat
        
       
        photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCameraSaveVC"{
            let imageToSend = wineImage
            guard let destinationVC = segue.destination as? CameraSaveVC else {
                return
            }
            destinationVC.wineImage = imageToSend
           
        }
    }
    
    
    @IBAction func libraryButtonTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }
}

extension CameraPreviewVC: AVCapturePhotoCaptureDelegate {
    // we setup the captureSession
    func setupCaptureSession() {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    // we find the device we need
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    // we setup input/output
    func setupInputOutput() {
        do {

            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            // we run this logic so there isn't multiple inputs
           
            if captureSession.inputs.isEmpty{
                captureSession.addInput(captureDeviceInput)
           }
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            // we run this logic so there isn't multiple outputs
    
            if captureSession.outputs.isEmpty {
                captureSession.addOutput(photoOutput!)
            }
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // we setup the camera layer. It is set to the frame of the cameraView
    func setupPreviewLayer() {
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.frame = cameraView.frame
    
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        
    }
    // we run the session.
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    // we end the session
    func endRunningSession() {
        captureSession.stopRunning()
        guard let _ = photoOutput else {
            print("no photo output")
            return
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 4, orientation: .right)
            
            wineImage = image
            performSegue(withIdentifier: "toCameraSaveVC", sender: nil)
            endRunningSession()
            
        }
    }
}

extension CameraPreviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let imagePicked = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        self.wineImage = imagePicked
        performSegue(withIdentifier: "toCameraSaveVC", sender: nil)
        print("imagePickerController func called")
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker has been canceled")
        dismiss(animated: true)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
