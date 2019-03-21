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

        
    }
    
    
    @IBAction func snapPhotoButtonTapped(_ sender: UIButton) {
        
        let settings = AVCapturePhotoSettings()
        
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 20,
                             kCVPixelBufferHeightKey as String: 20]
        settings.previewPhotoFormat = previewFormat
        
        photoOutput?.capturePhoto(with: settings, delegate: self)
        endRunningSession()
        showActionSheet()
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
        guard let photoOutput = photoOutput else {
            print("no photo output")
            return
        }
        
        captureSession.removeOutput(photoOutput)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 4, orientation: .up)
    
            self.wineImage = image
            
            
        }
    }
    
    @objc func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let redo = UIAlertAction(title: "Redo", style: .destructive) { (action) in
            self.startRunningCaptureSession()
          
        }
        
        let save = UIAlertAction(title: "Save Photo", style: .default) { (action) in
            let imagePicked = self.wineImage
            let detailVC = Detail_CreateVC()
            
            detailVC.wineImage = imagePicked
            
            self.navigationController?.popViewController(animated: true)
        }
        actionSheet.addAction(save)
        actionSheet.addAction(redo)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
