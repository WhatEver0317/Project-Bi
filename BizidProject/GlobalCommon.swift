//
//  GlobalCommon.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/7.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import Foundation
import UIKit


typealias CompletionCallback = (success:Bool, error:String?) -> Void
typealias CompletionWithResult = (success:Bool, result:AnyObject?) -> Void
typealias CompletionWithSuccessOnly = (success:Bool) -> Void
typealias ContactInfoArray = [Dictionary<String, String>]
typealias ContactDictionary = Dictionary<String, String>


// SharedApplicationDelegate
let SharedApplicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


// Constants
let kToWelcome = "ToWelcome"
let kMainStoryboard = "Main"
let kMainTabBarPage = "MainTabBarPage"
let kWelcomePage = "WelcomePage"
let kWelcomeNavigation = "WelcomeNavigationController"
let kToLogin = "ToLogin"
let kToMainTabBar = "ToMainTabBar"
let kToScan = "ToScan"
let kToSignUp2 = "ToSignUp2"
let kToDetailView = "ToDetailView"
let kContactInfoDetailCell = "ContactInfoDetailCell"
let kToProfileEditView = "ToProfileEditView"
let kToQRCode = "ToQRCodeView"
let kToImageCroper = "ToImageCroper"

// Screen and sizes
let screenBounds:CGRect = UIScreen.mainScreen().bounds
let screenSize   = screenBounds.size
let screenWidth  = screenSize.width
let kScreenHeight = screenSize.height
let gridWidth : CGFloat = (screenSize.width/2)-5.0
let navigationHeight : CGFloat = 44.0
let statubarHeight : CGFloat = 20.0
let navigationHeaderAndStatusbarHeight : CGFloat = navigationHeight + statubarHeight
let kSignupPortraitImageSize = CGSize(width: 140, height: 140)
let kDetailPortraitSize = CGSize(width: 90, height: 90)
let kPortraitCompressionQuality:CGFloat = 0.001

// UserDefaults
let standardUserDefaults = NSUserDefaults.standardUserDefaults()
let kContactInfoUserDefaults = "ContactInfoUserDefaults"
let kContactInfoHeadUserDefaults = "ContactInfoHeadUserDefaults"
let kObjectIDUserDefaults = "ObjectIDUserDefaults"
let kNameUserDefaults = "NameUserDefaults"
let kPortraitUserDefaults = "PortraitUserDefaults"
let kCompanyUserDefaults = "CompanyUserDefaults"
let kPositionUserDefaults = "PositionUserDefaults"
let kDefaultPortraitImage = UIImage(named: "DefaultPortrait.png")
let kSignupEmail = "SignupEmail"
let kSignupPassword = "SignupPassword"

// CoreData
let kEntityOfContacts = "Contacts"

// Colors
let MAINCOLOR = UIColor(rgba: "#50D2C2")
let GREEN = UIColor(rgba: "#50D2C2")
let DARK_GREEN = UIColor(rgba: "#26A69A")


