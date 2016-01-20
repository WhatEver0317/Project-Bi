//
//  IndexedContactsViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/10/1.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit


class IndexedContactsViewController: UIViewController, SphereMenuDelegate, UITableViewDataSource, UITableViewDelegate{//, AddFriendBySearchAlertDelegate {
    
    /* type to represent table items
    `section` stores a `UITableView` section */
    class User: NSObject {
        let data: Contacts
        let name: String
        var section: Int?
        
        init(data: Contacts) {
            self.data = data
            self.name = data.contactInfoHead["fullName"]!
        }
    }
    
    // custom type to represent table sections
    class Section {
        var users: [User] = []
        
        func addUser(user: User) {
            self.users.append(user)
        }
    }
    
    
    // `UIKit` convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as! UILocalizedIndexedCollation
    
    // table sections
    var sections: [Section] = []
    
    private func createSections() -> [Section]
    {
        // create users from the name list
        var users: [User] = []
        for contact in contactsArray {
            let user = User(data: contact)
            user.section = self.collation.sectionForObject(user, collationStringSelector: "name")
            users.append(user)
        }
        
        // create empty sections
        var sections = [Section]()
        for _ in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each user in a section
        for user in users {
            sections[user.section!].addUser(user)
        }
        
        // sort each section
        for section in sections {
            section.users = self.collation.sortedArrayFromArray(section.users, collationStringSelector: "name") as! [User]
        }
        
        return sections
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    // MARK: - Constants
    let kContactsCellIdentifier = "ContactsCell"
    
    // MARK: - Variables
    var addMenu:SphereMenu = SphereMenu()
    var contactsArray = [Contacts]() {
        didSet {
            sections = createSections()
        }
    }
    let emailComposer = EmailComposer()
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println(self.view.bounds.width)
        setupAddMenu()
        
        // Load contacts data
        ParseHelper.initializeCoreDataOfContacts { (success, error) -> Void in
            if success {
                // Load contacts data
                self.contactsArray = Contacts.fetchAllContactsFromCoreData()
                self.contactsTableView.reloadData()
            } else {
                GlobalHUD.showErrorHUDForView(self.view, withMessage: "Update contacts failed.", animated: true, hide: true, delay: 2)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addMenu.hideAllViews(false)
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        // Load contacts data
        self.contactsArray = Contacts.fetchAllContactsFromCoreData()
        self.contactsTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        addMenu.shrinkSubmenu()
        addMenu.hideAllViews(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegates
    // MARK: - SphereMenuDelegate
    func sphereDidSelected(index: Int) {
        println("\(index)")
        switch index {
        case 0: emailButtonPressed()
        case 1: searchButtonPressed()
        case 2: scanButtonPressed()
        default:break
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            return self.sections[section].users.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = self.sections[indexPath.section].users[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(kContactsCellIdentifier, forIndexPath: indexPath) as! ContactsTableViewCell
        
        let contactInfoHead = user.data.contactInfoHead
        let portrait = user.data.portrait
        
        cell.portraitThumbnail.makeCircularImage(UIImage(data: portrait)!, withSize: CGSize(width: 55, height: 55))
        cell.fullNameLabel.text = contactInfoHead["fullName"]
        cell.companyLabel.text = contactInfoHead["company"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kToDetailView, sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Section headers appear above each `UITableView` section
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String? {
            // do not display empty `Section`s
            if !self.sections[section].users.isEmpty {
                return self.collation.sectionTitles[section] as? String
            }
            return ""
    }
    
    // Section index titles displayed to the right of the `UITableView`
    func sectionIndexTitlesForTableView(tableView: UITableView)
        -> [AnyObject] {
            return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        atIndex index: Int)
        -> Int {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    
    // MARK: - AddFriendBySearchAlertDelegate
    func addFriendBySearchEmail(email: String) {
        if ( count(email) == 0 ) {
            GlobalHUD.showErrorHUDForView(self.view, withMessage: "You must input a friend's email.", animated: true, hide: true, delay: 2)
            return
        }
        
        ParseHelper.createFriendByEmail(email, completion: { (success, error) -> Void in
            if !success {
                // "Couldn't add the friend."
                GlobalHUD.showErrorHUDForView(self.view, withMessage: error, animated: true, hide: true, delay: 2)
            } else {
                // Load contacts data
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.contactsArray = Contacts.fetchAllContactsFromCoreData()
                        self.contactsTableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    // MARK: - Event Responses
    // Add a friend by searching email
    func searchButtonPressed()
    {
        /* This part code may cause a textfield bug
        //        let addFriendAlertController = AddFriendBySearchAlertController(title: "Add a friend", message: "Please enter his/her Bizid:", preferredStyle: .Alert)
        //        addFriendAlertController.delegate = self
        //        presentViewController(addFriendAlertController, animated: true, completion: nil)
        */
        
        var emailTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add a friend", message: "Please enter his/her Bizid:", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { [unowned self, alertController] (action: UIAlertAction!) in
            
//            if let emailTextField = ac.textFields![0] as? UITextField {
//                self.addFriendBySearchEmail(emailTextField.text)
//            } else {
//                self.addFriendBySearchEmail("")
//            }
            
            if let email = emailTextField?.text {
                self.addFriendBySearchEmail(email)
            } else {
                print("No Username entered")
                self.addFriendBySearchEmail("")
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            emailTextField = textField
            emailTextField!.placeholder = "<E-mail>"
        }
        
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)

        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = sender as? NSIndexPath {
            let user = self.sections[indexPath.section].users[indexPath.row]
            if segue.identifier == kToDetailView {
                var destination = segue.destinationViewController as? UIViewController
                if let navigationController = destination as? UINavigationController {
                    destination = navigationController.visibleViewController
                }
                
                if let detailVC = destination as? DetailViewController {
                    let contactInfoClass = ContactInfo()
                    contactInfoClass.contactInfoDic = ContactDictionary()
                    contactInfoClass.contactInfoDic = user.data.contactInfo
                    detailVC.contactInfoArray = contactInfoClass.contactInfoDicToArray()
                    detailVC.contactInfoHead = user.data.contactInfoHead
                    let portraitData = user.data.portrait
                    detailVC.portrait = UIImage(data: portraitData)!
                }
            }
        }
        
    }
    
    
    
    
    // MARK: - Getters & Setters
    
    // MARK: - Other Methods
    func setupAddMenu()
    {
        let start = UIImage(named: "add")
        let image1 = UIImage(named: "scan")
        let image2 = UIImage(named: "search")
        let image3 = UIImage(named: "email")
        var images:[UIImage] = [image3!, image2!, image1!]
        addMenu = SphereMenu(startPoint: CGPointMake(self.view.frame.width-(self.view.frame.width * 0.072), 42), startImage: start!, submenuImages:images, tapToDismiss:true)
        addMenu.delegate = self
        self.navigationController?.view.addSubview(addMenu)
    }
    
    func scanButtonPressed()
    {
        self.performSegueWithIdentifier(kToScan, sender: self)
    }
    
    
    func emailButtonPressed()
    {
        let configuredMailComposeViewController = emailComposer.configuredMailComposeViewController()
        if emailComposer.canSendMail() {
            presentViewController(configuredMailComposeViewController, animated: true, completion: nil)
        } else {
            emailComposer.showSendMailErrorAlert()
        }
    }
}
