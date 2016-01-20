//
//  ContactInfo.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/11.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation

class ContactInfo {
    
    var cellPhone:String //{ didSet { contactInfoDic["cellPhone"] =  self.cellPhone } }
    var email:String //{ didSet { contactInfoDic["email"] =  self.email } }
    var facebook:String //{ didSet { contactInfoDic["facebook"] =  self.facebook } }
    var twitter:String //{ didSet { contactInfoDic["twitter"] =  self.twitter } }
    var website:String //{ didSet { contactInfoDic["website"] =  self.website } }
    var github:String //{ didSet { contactInfoDic["github"] =  self.github } }
    var linkedIn:String //{ didSet { contactInfoDic["linkedIn"] =  self.linkedIn } }
    var skype:String //{ didSet { contactInfoDic["flickr"] =  self.flickr } }
    var whatsapp:String //{ didSet { contactInfoDic["whatsapp"] =  self.whatsapp } }
    
    // Dictionary<String, String>()
    var contactInfoDic = ContactDictionary()
    
    init()
    {
        self.cellPhone = ""
        self.email = ""
        self.facebook = ""
        self.twitter = ""
        self.website = ""
        self.github = ""
        self.linkedIn = ""
        self.skype = ""
        self.whatsapp = ""
        
        contactInfoDic = [
            "Cell Phone":self.cellPhone,
            "E-Mail":self.email,
            "Facebook":self.facebook,
            "Twitter":self.twitter,
            "Website":self.website,
            "Github":self.github,
            "LinkedIn":self.linkedIn,
            "Skype":self.skype,
            "Whatsapp":self.whatsapp]

//        fetchMyContactDataFromUserDefaults { (success) -> Void in }
    }
    
    func saveContactDataToUserDefaults(completion:CompletionWithSuccessOnly)
    {
        standardUserDefaults.removeObjectForKey(kContactInfoUserDefaults)
        standardUserDefaults.setObject(contactInfoDic, forKey: kContactInfoUserDefaults)
        if standardUserDefaults.synchronize() {
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
    // Fetch data from
    func fetchMyContactDataFromUserDefaults(completion:CompletionWithSuccessOnly)
    {
        contactInfoDic = ContactDictionary()
        if let data = standardUserDefaults.valueForKey(kContactInfoUserDefaults) as? Dictionary<String, String> {
            contactInfoDic = data
            updateVariables(contactInfoDic)
            completion(success: true)
        } else {
            completion(success: false)
        }
    }
    
    // Return an array for contactInfo table view
    // * WARNING: Must be used after passed data to contactInfoDic *
    func contactInfoDicToArray() -> ContactInfoArray//[Dictionary<String, String>]
    {
        var contactArray = ContactInfoArray()
        contactArray.append(["Cell Phone":contactInfoDic["Cell Phone"] ?? ""])
        contactArray.append(["E-Mail":contactInfoDic["E-Mail"] ?? ""])
        contactArray.append(["Facebook":contactInfoDic["Facebook"] ?? ""])
        contactArray.append(["Twitter":contactInfoDic["Twitter"] ?? ""])
        contactArray.append(["Website":contactInfoDic["Website"] ?? ""])
        contactArray.append(["GitHub":contactInfoDic["GitHub"] ?? ""])
        contactArray.append(["LinkedIn":contactInfoDic["LinkedIn"] ?? ""])
        contactArray.append(["Skype":contactInfoDic["Skype"] ?? ""])
        contactArray.append(["Whatsapp":contactInfoDic["Whatsapp"] ?? ""])
        return contactArray
    }
    
    func contactInfoArrayToDic(array:ContactInfoArray)
    {
        contactInfoDic = ContactDictionary()
        var contactInfoDicTemp = contactInfoDic
        for element in array {
            if let key = element.getFirstKey() {
                contactInfoDicTemp[key] = element[key]
            }
        }
        contactInfoDic = contactInfoDicTemp
        updateVariables(contactInfoDic)
    }
    
    func updateVariables(contactInfoDic:ContactDictionary)
    {
        cellPhone = contactInfoDic["Cell Phone"] ?? ""
        email = contactInfoDic["E-mail"] ?? ""
        facebook = contactInfoDic["Facebook"] ?? ""
        twitter = contactInfoDic["Twitter"] ?? ""
        website = contactInfoDic["Website"] ?? ""
        github = contactInfoDic["Github"] ?? ""
        linkedIn = contactInfoDic["LinkedIn"] ?? ""
        skype = contactInfoDic["Skype"] ?? ""
        whatsapp = contactInfoDic["Whatsapp"] ?? ""
    }

    class func clearContactInfoDataInUserDefaults()
    {
        standardUserDefaults.removeObjectForKey(kContactInfoUserDefaults)
    }
    
    func rollbackContactInfoData(contactInfoDic:ContactDictionary)
    {
        self.contactInfoDic = ContactDictionary()
        self.contactInfoDic = contactInfoDic
        saveContactDataToUserDefaults { (success) -> Void in
            if !success {
                self.saveContactDataToUserDefaults({ (success) -> Void in })
            }
        }
    }

    
}