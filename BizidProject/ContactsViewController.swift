////
////  ViewController.swift
////  BizidProject
////
////  Created by GaoYuan on 15/9/3.
////  Copyright (c) 2015年 Yuan Gao. All rights reserved.
////
//
//import UIKit
//
//
//class ContactsViewController: UIViewController, SphereMenuDelegate, UITableViewDataSource, UITableViewDelegate{//, AddFriendBySearchAlertDelegate {
//    
//    // MARK: - Properties
//    
//    @IBOutlet weak var contactsTableView: UITableView!
//    
//    // MARK: - Constants
//    let kContactsCellIdentifier = "ContactsCell"
//    
//    // MARK: - Variables
//    var addMenu:SphereMenu = SphereMenu()
//    var contactsArray = [Contacts]()
//    let emailComposer = EmailComposer()
//    
//    
//    // Used for passing data to detail view controller
//    
////    let contactInfo = ContactInfo()
////    let contactInfoHead = ContactInfoHead()
//    
//    
//    
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupAddMenu()
//        
//        // Load contacts data
//        ParseHelper.initializeCoreDataOfContacts { (success, error) -> Void in
//            if success {
//                // Load contacts data
//                self.contactsArray = Contacts.fetchAllContactsFromCoreData()
//                self.contactsTableView.reloadData()
//            } else {
//                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Update contacts failed.", animated: true, hide: true, delay: 1.5)
//            }
//        }
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        addMenu.hideAllViews(false)
//        contactsTableView.delegate = self
//        contactsTableView.dataSource = self
//        
//        // Load contacts data
//        self.contactsArray = Contacts.fetchAllContactsFromCoreData()
//        self.contactsTableView.reloadData()
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        addMenu.shrinkSubmenu()
//        addMenu.hideAllViews(true)
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Delegates
//    // MARK: - SphereMenuDelegate
//    func sphereDidSelected(index: Int) {
//        println("\(index)")
//        switch index {
//        case 0: emailButtonPressed()
//        case 1: searchButtonPressed()
//        case 2: scanButtonPressed()
//        default:break
//        }
//    }
//    
//    // MARK: - UITableViewDataSource, UITableViewDelegate
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contactsArray.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(kContactsCellIdentifier, forIndexPath: indexPath) as! ContactsTableViewCell
//        
//        let contactInfoHead = contactsArray[indexPath.row].contactInfoHead
//        let portrait = contactsArray[indexPath.row].portrait
//        
//        cell.portraitThumbnail.makeCircularImage(UIImage(data: portrait)!, withSize: CGSize(width: 55, height: 55))
//        cell.fullNameLabel.text = contactInfoHead["fullName"]
//        cell.companyLabel.text = contactInfoHead["company"]
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier(kToDetailView, sender: indexPath)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    
//    
//    // MARK: - AddFriendBySearchAlertDelegate
//    func addFriendBySearchEmail(email: String) {
//        if ( count(email) == 0 ) {
//            GlobalHUD.showErrorHUDForView(self.view, withMessage: "You must input a friend's email.", animated: true, hide: true, delay: 2)
//            return
//        }
//        
//        ParseHelper.createFriendByEmail(email, completion: { (success, error) -> Void in
//            if !success {
//                // "Couldn't add the friend."
//                GlobalHUD.showErrorHUDForView(self.view, withMessage: error, animated: true, hide: true, delay: 2)
//            } else {
//                // Load contacts data
//                self.contactsArray = Contacts.fetchAllContactsFromCoreData()
//                self.contactsArray.sort({ $0.contactInfoHead["fullName"] > $1.contactInfoHead["fullName"] })
//                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        
//                        self.contactsTableView.reloadData()
//                    }
//                }
//            }
//        })
//        
//    }
//    
//    
//    // MARK: - Event Responses
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let indexPath = sender as? NSIndexPath {
//            if segue.identifier == kToDetailView {
//                var destination = segue.destinationViewController as? UIViewController
//                if let navigationController = destination as? UINavigationController {
//                    destination = navigationController.visibleViewController
//                }
//                
//                if let detailVC = destination as? DetailViewController {
//                    let contactInfoClass = ContactInfo()
//                    contactInfoClass.contactInfoDic = ContactDictionary()
//                    contactInfoClass.contactInfoDic = contactsArray[indexPath.row].contactInfo
//                    detailVC.contactInfoArray = contactInfoClass.contactInfoDicToArray()
//                    detailVC.contactInfoHead = contactsArray[indexPath.row].contactInfoHead
//                    let portraitData = contactsArray[indexPath.row].portrait
//                    detailVC.portrait = UIImage(data: portraitData)!
//                }
//            }
//        }
//        
//    }
//    
//    
//    
//    
//    // MARK: - Getters & Setters
//    
//    // MARK: - Other Methods
//    func setupAddMenu()
//    {
//        let start = UIImage(named: "add")
//        let image1 = UIImage(named: "scan")
//        let image2 = UIImage(named: "search")
//        let image3 = UIImage(named: "email")
//        var images:[UIImage] = [image3!, image2!, image1!]
//        addMenu = SphereMenu(startPoint: CGPointMake(self.view.frame.width-(self.view.frame.width * 0.072), 42), startImage: start!, submenuImages:images, tapToDismiss:true)
//        addMenu.delegate = self
//        self.navigationController?.view.addSubview(addMenu)
//    }
//    
//    func scanButtonPressed()
//    {
//        self.performSegueWithIdentifier(kToScan, sender: self)
//    }
//    
//    
//    func searchButtonPressed()
//    {
//        /* This part code may cause a textfield bug
//        //        let addFriendAlertController = AddFriendBySearchAlertController(title: "Add a friend", message: "Please enter his/her Bizid:", preferredStyle: .Alert)
//        //        addFriendAlertController.delegate = self
//        //        presentViewController(addFriendAlertController, animated: true, completion: nil)
//        */
//        
////        let ac = UIAlertController(title: "Add a friend", message: "Please enter his/her Bizid:", preferredStyle: .Alert)
////        ac.addTextFieldWithConfigurationHandler(nil)
////        
////        let addAction = UIAlertAction(title: "submit", style: .Default) { [unowned self, ac] (action: UIAlertAction!) in
////            if let email = (ac.textFields![0] as! UITextField).text {
////                self.addFriendBySearchEmail(email)
////            } else {
////                self.addFriendBySearchEmail("")
////            }
////        }
////        
////        ac.addAction(addAction)
////        
////        presentViewController(ac, animated: true, completion: nil)
//        
//    }
//
//    
//    func emailButtonPressed()
//    {
//        let configuredMailComposeViewController = emailComposer.configuredMailComposeViewController()
//        if emailComposer.canSendMail() {
//            presentViewController(configuredMailComposeViewController, animated: true, completion: nil)
//        } else {
//            emailComposer.showSendMailErrorAlert()
//        }
//    }
//}
//
