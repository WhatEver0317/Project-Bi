//
//  QRCodeViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/10/3.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit
import Parse

class QRCodeViewController: UIViewController {

        
        //MARK: - Properties
        
        @IBOutlet weak var imgQRCode: UIImageView!
        @IBOutlet weak var slider: UISlider!
        
        
        
        //MARK: - Variables
        
        var qrcodeImage: CIImage!
        var uniqueKey:NSString? = PFUser.currentUser()?.email// should get the unique key or link from cloud server**************************/
        var blueFffectView:UIVisualEffectView!
        
        
        
        //MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            generateQRImage()
        }
        
        //MARK: - QR Image Generate
        func generateQRImage() {
            if qrcodeImage == nil {
                if uniqueKey == nil || uniqueKey == "" {
                    return
                }
                
                //加密data
                let base64EncodedString = dataWithBase64EncodedString(NSString(string: uniqueKey!))
                
                let data = base64EncodedString.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
                
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                filter.setValue(data, forKey: "inputMessage")
                filter.setValue("Q", forKey: "inputCorrectionLevel")
                
                qrcodeImage = filter.outputImage
                
                displayQRCodeImage()
            }
            else {
                imgQRCode.image = nil
                qrcodeImage = nil
            }
        }
        
        
        @IBAction func changeImageViewScale(sender: AnyObject) {
            imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(slider.value), CGFloat(slider.value))
        }
        
        func displayQRCodeImage() {
            let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent().size.width
            let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent().size.height
            
            let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
            
            imgQRCode.image = UIImage(CIImage: transformedImage)
        }

    }
    
    //MAKR: - Base64 Encoding
    
    private func dataWithBase64EncodedString(data:NSString) -> NSString {
        let encodingData = data.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = encodingData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0)) ?? data
        return base64String
    }


