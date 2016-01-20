//
//  ContactInfoHead.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/11.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation


class ContactInfoHead {
    
    var objectID:String //{ didSet { contactInfoHeadDic["objectID"] =  self.objectID } }
    var email:String //{ didSet { contactInfoHeadDic["email"] =  self.email } }
    var fullName:String //{ didSet { contactInfoHeadDic["fullName"] =  self.fullName } }
    var company:String //{ didSet { contactInfoHeadDic["company"] =  self.company } }
    var position:String //{ didSet { contactInfoHeadDic["position"] =  self.position } }
    var portrait:NSData
//    var background:NSData
    
    // Dictionary<String, String>()
    var contactInfoHeadDic = ContactDictionary()
    
    init()
    {
        self.objectID = ""
        self.email = ""
        self.fullName = ""
        self.company = ""
        self.position = ""
        self.portrait = UIImagePNGRepresentation(kDefaultPortraitImage)

        contactInfoHeadDic = [
            "objectID":self.objectID,
            "email":self.email,
            "fullName":self.fullName,
            "company":self.company,
            "position":self.position]
        
//        fetchContactInfoHeadDataFromUserDefaults { (success) -> Void in }
//        fetchPortraitDataFromUserDefaults { (success) -> Void in }
        println("init in ContactInfoHead")
        println(contactInfoHeadDic)
    }
    
    func saveContactInfoHeadDataToUserDefaults(completion:CompletionWithSuccessOnly)
    {
        // Save individual information into UserDefaults
        standardUserDefaults.removeObjectForKey(kContactInfoHeadUserDefaults)
        standardUserDefaults.setObject(contactInfoHeadDic, forKey: kContactInfoHeadUserDefaults)
        // Save individual portrait into UserDefaults
        standardUserDefaults.removeObjectForKey(kPortraitUserDefaults)
        standardUserDefaults.setObject(self.portrait, forKey: kPortraitUserDefaults)
        if standardUserDefaults.synchronize() {
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
    func fetchContactInfoHeadDataFromUserDefaults(completion:CompletionWithSuccessOnly)
    {
        contactInfoHeadDic = ContactDictionary()
        // Get contact head information from UserDefaults
        if let data = standardUserDefaults.valueForKey(kContactInfoHeadUserDefaults) as? Dictionary<String, String> {
            contactInfoHeadDic = data
            updateVariables(contactInfoHeadDic)
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
    func fetchPortraitDataFromUserDefaults(completion:CompletionWithSuccessOnly)
    {
        // Get contact head information from UserDefaults
        if let data = standardUserDefaults.valueForKey(kPortraitUserDefaults) as? NSData {
            portrait = data
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
    class func clearContactInfoHeadDataInUserDefaults()
    {
        standardUserDefaults.removeObjectForKey(kContactInfoHeadUserDefaults)
        standardUserDefaults.removeObjectForKey(kPortraitUserDefaults)
    }
    
    func updateVariables(contactInfoHeadDic:ContactDictionary)
    {
        self.objectID = contactInfoHeadDic["objectID"]!
        self.email = contactInfoHeadDic["email"]!
        self.fullName = contactInfoHeadDic["fullName"]!
        self.company = contactInfoHeadDic["company"] ?? ""
        self.position = contactInfoHeadDic["position"] ?? ""
    }
    
//    func updateContactInfoHeadDicByVariables()
//    {
//        contactInfoHeadDic["objectID"] = self.objectID
//        contactInfoHeadDic["email"] = self.email
//        contactInfoHeadDic["fullName"] = self.fullName
//        contactInfoHeadDic["company"] = self.company
//        contactInfoHeadDic["position"] = self.position
//    }
    
    func rollbackContactInfoHeadData(contactInfoHeadDic:ContactDictionary, portrait:NSData)
    {
        self.contactInfoHeadDic = ContactDictionary()
        self.contactInfoHeadDic = contactInfoHeadDic
        self.portrait = portrait
        saveContactInfoHeadDataToUserDefaults { (success) -> Void in
            if !success {
                self.saveContactInfoHeadDataToUserDefaults({ (success) -> Void in })
            }
        }
    }
    
    
}



