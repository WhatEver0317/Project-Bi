//
//  Contacts.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/14.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation
import CoreData

class Contacts: NSManagedObject {

    @NSManaged var contactInfo: ContactDictionary
    @NSManaged var contactInfoHead: ContactDictionary
    @NSManaged var portrait: NSData

    // These methods should be moved out before updating contacts module
    class func fetchAllContactsFromCoreData() -> [Contacts]
    {
        var contactsArray:[Contacts] = [Contacts]()
        if let managedObjectContext = SharedApplicationDelegate.managedObjectContext {
            var fetchError: NSError?
            let fetchRequest = NSFetchRequest(entityName: "Contacts")
            contactsArray = managedObjectContext.executeFetchRequest(fetchRequest, error: &fetchError) as! [Contacts]
            
            if fetchError != nil {
                println("\(fetchError?.description)")
            }
        }
        return contactsArray
    }
    
    class func addFriendToCoreData(portrait:NSData?, contactInfoHead:ContactDictionary?, contactInfo:ContactDictionary?)
    {
        let managedContext = SharedApplicationDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedContext)
        let contactsManagedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Contacts
        
        contactsManagedObject.setValue(portrait, forKey: "portrait")
        contactsManagedObject.setValue(contactInfoHead, forKey: "contactInfoHead")
        contactsManagedObject.setValue(contactInfo, forKey: "contactInfo")
        
        var saveError: NSError?
        if managedContext.save(&saveError) {
            println("Could not save \(saveError?.message())")
        }
    }
    
    class func removeAllData()
    {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Contacts")
            var e: NSError?
            
            if let items = managedObjectContext.executeFetchRequest(fetchRequest, error: &e) {
                for item in items {
                    managedObjectContext.deleteObject(item as! NSManagedObject)
                }
            }
            
            if e != nil {
                println("Failed to retrieve record needed to delete: \(e!.localizedDescription)")
            }
        }
    }
    
    class func isTheFriendExisted(email:String) -> Bool
    {
        var isExisted = false
        let contacts = self.fetchAllContactsFromCoreData()
        
        for friend in contacts {
            if friend.contactInfoHead["email"] == email {
                isExisted = true
                break
            } else {
                isExisted = false
            }
        }
        return isExisted
    }
}
