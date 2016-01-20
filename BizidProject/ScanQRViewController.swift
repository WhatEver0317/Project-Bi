//
//  ScanQRViewController.swift
//  Bizid
//
//  Created by GaoYuan on 15/6/3.
//  Copyright (c) 2015年 GaoYuan. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {

    
    //MARK: - Interfaces
    var uniqueKey:String?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: - Variables
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createVideoCapture()
        createCaptureFrame()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Delegates
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession?.stopRunning()
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                uniqueKey = metadataObj.stringValue
                
                if uniqueKey != nil {
                    
                    let email = decodingBase64Data(uniqueKey!)
                    
                    //Update CoreData and Cloud by uising Unique Key **************************/
                    ParseHelper.createFriendByEmail(email, completion: { (success, error) -> Void in
                        if success && error == nil {
                            self.showAlertWithMessage("Add your new friend successfully!")
                        } else {
                            self.showAlertWithMessage(error!)//"Can't add your new friend, Please try again!")
                        }
                    })
                } else {
                    showAlertWithMessage("Scan failure! Please try again!")
                }
                
            }
        }
    }
    
    // UIAlertViewDelegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    //MARK: - QR Code Capture
    
    func createVideoCapture()
    {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
    }
    
    func createCaptureFrame()
    {
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }

    
    // MARK: - Decoding Base64 String
    private func decodingBase64Data(data:String) -> String {
        let nsdata = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(0))
        if nsdata == nil {
             return data
        } else {
            let decodedString:String = (NSString(data: nsdata!, encoding: NSUTF8StringEncoding) ?? NSString(string: data)) as String
            return decodedString
        }
        
    }
    
    private func showAlertWithMessage(message: String) {
        UIAlertView(title: nil, message: message, delegate: self, cancelButtonTitle: "OK").show()
    }
    
    
}
