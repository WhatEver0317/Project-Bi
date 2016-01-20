//
//  ParseHelper.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/7.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation
import Parse


class ParseHelper {
    
    // Check currently logged in user
    class func userLoggedIn() -> Bool
    {
        if (( PFUser.currentUser() ) != nil) {
            return true
        } else {
            return false
        }
    }
    
    // Return current user
    class func currentUser() -> PFUser
    {
        return PFUser.currentUser()!
    }
    
    // Sign up user and update user information
    class func signupUserWithEmail(username:String, andPassword password:String, completion:CompletionCallback)
    {
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
            return
        }
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = username
        
        var signUpError:NSError?
        user.signUp(&signUpError)
        
        if signUpError == nil {
            println("user account was created")
            completion(success: true, error: nil)
        } else {
            println("sign error:\(signUpError!.code), \(signUpError!.description)")
            completion(success: false, error: signUpError?.message())
        }
    }
    
    // Update user data in Parse
    class func updateUserDataInParseWithContactInfo(contactInfo:ContactInfo, andContactInfoHead contactInfoHead:ContactInfoHead, completion:CompletionCallback)
    {
        
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            let portraitFile = PFFile(name: "\(contactInfoHead.fullName)", data: contactInfoHead.portrait)
            let contactInfoData = contactInfo.contactInfoDic
            let contactInfoHeadData = contactInfoHead.contactInfoHeadDic
            var error:NSError?
            if let currentUserObjectID = PFUser.currentUser()?.objectId {
                
                let userQuery = PFUser.query()
                let user = userQuery?.getObjectWithId(currentUserObjectID, error: &error) as! PFUser
                var saveError:NSError?
                if error == nil {
                    user["portrait"] = portraitFile
                    user["contactInfo"] = contactInfoData
                    user["contactInfoHead"] = contactInfoHeadData
                    user.save(&saveError)
                    if saveError == nil {
                        completion(success: true, error: nil)
                    } else {
                        completion(success: false, error: saveError?.message())
                    }
                } else {
                    completion(success: false, error: error?.message())
                }
            } else {
                completion(success: false, error: "User cannot find. Please login again.")
            }
            
            //Save data to Parse's FriendList Class
            var objectsArray = [PFObject]()
            if let currentUser = PFUser.currentUser() {
                let objectQuery = PFQuery(className: "Contacts")
                objectQuery.whereKey("friend", equalTo: currentUser)
                
                objectQuery.findObjectsInBackgroundWithBlock { (friendList:[AnyObject]?, error:NSError?) -> Void in
                    if let friendList = friendList as? [PFObject] where error == nil {
                        for myInfo in friendList {
                            myInfo["contactInfo"] = contactInfoData
                            myInfo["portrait"] = portraitFile
                            myInfo["contactInfoHead"] = contactInfoHeadData
                            
                            objectsArray.append(myInfo)
                        }
                        PFObject.saveAllInBackground(objectsArray, block: { (success:Bool, error:NSError?) -> Void in
                            if success && error == nil {
                                println("save all successful")
                            } else {
                                println("save all unsuccessful")
                                println("fetch friend list error:\(error!.code), \(error!.description)")
                                UIAlertView(title: "Error", message: "\(error!.description)", delegate: nil, cancelButtonTitle: "OK").show()
                            }
                        })
                    }
            }
            
            }
        }
    }
    
    
    
    // Log in with email and password
    class func loginUserWithEmail(username:String, andPassword password:String, completion:CompletionCallback)
    {
        var loginError:NSError?
        
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            // Log in user
            PFUser.logInWithUsername(username, password: password, error: &loginError)
            if loginError == nil {
                println("----------Login successful----------")
                completion(success: true, error: nil)
            } else {
                println("----------Login failed-----------")
                let errorString = loginError!.userInfo?["error"] as? String
                println(errorString)
                completion(success: false, error: errorString)
            }
        }
    }
    
    // Verify user email
    class func userEmailVerified() -> Bool
    {
        if let currentUser = PFUser.currentUser() {
            if let verified = currentUser["emailVerified"] as? Bool {
                if verified == true {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // Resend verification email
    class func resendVerificationEmail()
    {
        let currentUser = PFUser.currentUser()
        let email = currentUser?.email
        currentUser?.email = ""
        currentUser?.saveInBackgroundWithBlock { success, error in
            if let e = error {
                return
            }
            currentUser?.email = email
            currentUser?.saveInBackgroundWithBlock {success, error in
                if let e = error {
                    currentUser?.email = email
                    currentUser?.saveInBackground()
                    return
                }
            }
        }
    }
    
    // Log out user
    class func logoutUser(completion:CompletionCallback)
    {
        var logoutError:NSError?
        
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            // Log out user
            PFUser.logOutInBackgroundWithBlock { (logoutError) -> Void in
                if logoutError == nil {
                    completion(success: true, error: nil)
                } else {
                    completion(success: false, error: logoutError?.message())
                }
            }
        }
    }
    
    
    // Initialize user data in userdefaults after successfully log in or sign up
    class func initializeUserDataInUserDefaults(completion:CompletionCallback)
    {
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            if let currentUserObjectID = PFUser.currentUser()!.objectId {
                // Clear user data
                ContactInfo.clearContactInfoDataInUserDefaults()
                ContactInfoHead.clearContactInfoHeadDataInUserDefaults()
                
                var contactInfo = ContactInfo()
                var contactInfoHead = ContactInfoHead()
                // Get user data from Parse
                var error:NSError?
                let userQuery = PFUser.query()
                if let userData = userQuery?.getObjectWithId(currentUserObjectID, error: &error) as? PFUser {
                    contactInfoHead.contactInfoHeadDic = userData["contactInfoHead"] as! ContactDictionary
                    let portraitFile = userData["portrait"] as? PFFile
                    contactInfoHead.portrait = portraitFile?.getData() ?? UIImagePNGRepresentation(kDefaultPortraitImage)
                    contactInfo.contactInfoDic = userData["contactInfo"] as? ContactDictionary ?? ContactInfo().contactInfoDic
                    // Save user data into UserDefaults
                    contactInfoHead.saveContactInfoHeadDataToUserDefaults { (success) -> Void in }
                    contactInfo.saveContactDataToUserDefaults { (success) -> Void in }
                    
                    completion(success: true, error: nil)
                } else {
                    completion(success: false, error: error?.message())
                }
            }
        }
    }
    
    
    // Initialize contacts data in coredata
    class func initializeCoreDataOfContacts(completion:CompletionCallback)
    {
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            Contacts.removeAllData()
            
            if let currentUser = PFUser.currentUser() {
                // Get friend list
                let objectQuery = PFQuery(className: "Contacts")
                objectQuery.whereKey("createdBy", equalTo: currentUser)
                objectQuery.orderByAscending("name")
                
                objectQuery.findObjectsInBackgroundWithBlock { (friendList:[AnyObject]?, error:NSError?) -> Void in
                    if let friendList = friendList as? [PFObject] where error == nil {
                        for friend in friendList {
                            // Update CoreData
                            self.updateFriendInfoInCoreData(friend)
                        }
                        completion(success: true, error: nil)
                    } else {
                        completion(success: false, error: error?.message())
                    }
                }
            }
        }
    }
    
    class func updateFriendInfoInCoreData(friend:PFObject)
    {
        
        // Get portrait
        let portraitFile = friend["portrait"] as? PFFile
        let portrait = portraitFile!.getData()
        
        // Get contactInfoHead
        let contactInfoHead = friend["contactInfoHead"] as! ContactDictionary
        
        // Get contactInfo
        let contactInfo = friend["contactInfo"] as? ContactDictionary
        
        // Update CoreData
        Contacts.addFriendToCoreData(portrait, contactInfoHead: contactInfoHead, contactInfo: contactInfo)

    }
    
    class func createFriendByEmail(email:String, completion:CompletionCallback)
    {
        // Check network status
        let reachability = Reachability.reachabilityForInternetConnection()
        if !(reachability.isReachable()) {
            reachability.networkError(self)
            completion(success: false, error: "No Internet connection.")
        } else {
            
            if email == PFUser.currentUser()?.email {
                completion(success: false, error: "Can't add yourself.")
                return
            }
            
            if Contacts.isTheFriendExisted(email) {
                completion(success: false, error: "This friend is existed.")
            } else {
                
                // Get friend data from Parse User Class
                let userQuery = PFUser.query()
                userQuery?.whereKey("username", equalTo: email)
                userQuery?.getFirstObjectInBackgroundWithBlock({ (result:PFObject?, fetchError:NSError?) -> Void in
                    if let newFriend = result as? PFUser{
                        // Create the new friend
                        self.createNewFriend(newFriend, completion: { (success, error) -> Void in
                            if success == true && error == nil {
                                completion(success: true, error: nil)
                            } else {
                                completion(success: false, error: error)
                            }
                        })
                    } else {
                        completion(success: false, error: fetchError?.message())
                    }
                })
            }
            
        }
    }
    
    class func createNewFriend(newFriend:PFUser, completion: CompletionCallback)
    {
        // Create relation
        // Get parent
        let currentUser = PFUser.currentUser()
        
        // Save data
        let contacts = PFObject(className: "Contacts")
        contacts["friend"] = newFriend
        contacts["createdBy"] = currentUser
        
        
        // do isRequest later ******************/
        // pay attention to the dumps caused by nil  **********/
        contacts["contactInfoHead"] = newFriend["contactInfoHead"] as! ContactDictionary
        contacts["contactInfo"] = newFriend["contactInfo"] as? ContactDictionary ?? ContactInfo().contactInfoDic
        contacts["portrait"] = newFriend["portrait"] as? PFFile
        
        var contactsSaveError:NSError?
        contacts.save(&contactsSaveError)
        if contactsSaveError == nil {
            println("friend \(newFriend.username) is created")
            
            // update CoreData ****************/
            addFriendToCoreData(newFriend)
            completion(success: true, error: nil)
        } else {
            println("create friend error:\(contactsSaveError)")
            completion(success: false, error: contactsSaveError?.message())
        }
    }
    
    class func addFriendToCoreData(newFriend:PFUser)
    {
        let contactInfoHead = newFriend["contactInfoHead"] as! ContactDictionary
        let contactInfo = newFriend["contactInfo"] as? ContactDictionary ?? ContactInfo().contactInfoDic
        let portraitFile = newFriend["portrait"] as? PFFile
        let portrait = portraitFile!.getData() ?? NSData()
        Contacts.addFriendToCoreData(portrait, contactInfoHead: contactInfoHead, contactInfo: contactInfo)
    }

    
    // Fetch friends' locations
    class func fetchContactsLocation(myLatitude:CLLocationDegrees, myLongitude:CLLocationDegrees, completion: ([ContactLocation]?) -> Void)
    {
        var contactLocations = [ContactLocation]()
        var contactLocation = ContactLocation()
        let myLocation = PFGeoPoint(latitude: myLatitude, longitude: myLongitude)
        let contactsQuery = PFQuery(className:"Contacts")
        if let user = PFUser.currentUser() {
            contactsQuery.whereKey("createdBy", equalTo: user)
            contactsQuery.whereKey("location", nearGeoPoint: myLocation, withinMiles: 10.0)
            
            contactsQuery.findObjectsInBackgroundWithBlock({ (contacts:[AnyObject]?, error:NSError?) -> Void in
                if error != nil {
                    completion(nil)
                    return
                }
                
                if let friendLocations = contacts as? [PFObject] {
                    println(friendLocations.count)
                    for friendLocation in friendLocations {
                        let location = friendLocation["location"] as? PFGeoPoint ?? PFGeoPoint()
                        let contactInfoHead = friendLocation["contactInfoHead"] as! ContactDictionary
                        let contactInfo = friendLocation["contactInfo"] as! ContactDictionary
                        let portraitFile = friendLocation["portrait"] as! PFFile
                        
                        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        contactLocation.location = coordinate
                        contactLocation.contactInfoHead = contactInfoHead
                        contactLocation.contactInfo = contactInfo
                        contactLocation.thumnail = UIImage(data: portraitFile.getData()!)
                        contactLocations.append(contactLocation)
                    }
                    completion(contactLocations)
                } else {
                    completion(nil)
                }
            })
        } else {
            println("CurrentUser cannot find")
            completion(nil)
        }
    }
    
    
    
    class func updateMyLocation(latitude:CLLocationDegrees, longitude:CLLocationDegrees, completion: CompletionCallback)
    {
            // update my location
            let location = PFGeoPoint(latitude:latitude, longitude:longitude)
            var objectsArray = [PFObject]()
            let currentUser = PFUser.currentUser()
            let objectQuery = PFQuery(className: "Contacts")
            objectQuery.whereKey("friend", equalTo: currentUser!)
            
            objectQuery.findObjectsInBackgroundWithBlock { (friendList:[AnyObject]?, error:NSError?) -> Void in
                if error != nil {
                    return
                }
                if let friendList = friendList as? [PFObject] {
                    for myInfo in friendList {
                        myInfo["location"] = location
                        
                        objectsArray.append(myInfo)
                    }
                    PFObject.saveAllInBackground(objectsArray, block: { (success:Bool, error:NSError?) -> Void in
                        if success && error == nil {
                            println("save all location successful")
                            completion(success: success, error: error?.message())
                        } else {
                            println("save all failure")
                            println("fetch friend list error:\(error!.code), \(error!.description)")
                            completion(success: success, error: error?.message())
                        }
                    })
                }
            }
    }
    
    class func resetUserPosswordWithEmail(email:String, completion:CompletionCallback)
    {
        var error:NSError?
        
        PFUser.requestPasswordResetForEmail(email, error: &error)
        if error == nil {
            completion(success: true, error: nil)
        } else {
            completion(success: false, error: error?.message())
        }
    }
}