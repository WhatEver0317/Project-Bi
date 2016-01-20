//
//  MKPointAnnotation+AddVar.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/23.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation
import MapKit

private var CONTACT_INFO_PROPERTY = 0
private var CONTACT_INFO_HEAD_PROPERTY = 1
private var PORTRAIT_PROPERTY = 2
extension MKPointAnnotation {
    
    var contactInfo: ContactDictionary {
        get{
            let result = objc_getAssociatedObject(self, &CONTACT_INFO_PROPERTY) as? ContactDictionary
            if result?.count == 0 {
                return ContactDictionary()
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &CONTACT_INFO_PROPERTY, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
        
    }
    
    var contactInfoHead: ContactDictionary {
        get{
            let result = objc_getAssociatedObject(self, &CONTACT_INFO_HEAD_PROPERTY) as? ContactDictionary
            if result?.count == 0 {
                return ContactDictionary()
            }
            return result!
        }
        set{
            objc_setAssociatedObject(self, &CONTACT_INFO_HEAD_PROPERTY, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
        
    }
    
//    var portrait:NSData {
//        get {
//            if var result = objc_getAssociatedObject(self, &PORTRAIT_PROPERTY) as? NSData {
//                return result
//            } else {
//                return UIImagePNGRepresentation(kDefaultPortraitImage!)
//            }
//        }
//        
//        set {
//            objc_setAssociatedObject(self, &PORTRAIT_PROPERTY, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
//        }
//    }
}