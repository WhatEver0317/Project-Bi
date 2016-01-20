//
//  UIImageView+CircularImage.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/15.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeCircularImage(image:UIImage, withSize size:CGSize)
    {
        self.image = imageResize(image, sizeChange: size)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true;
        self.layer.borderWidth = 0
//        self.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}