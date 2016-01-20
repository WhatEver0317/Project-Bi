//
//  EmailComposer.swift
//  Bizid
//
//  Created by GaoYuan on 15/6/5.
//  Copyright (c) 2015年 GaoYuan. All rights reserved.
//

import Foundation
import MessageUI

class EmailComposer: NSObject, MFMailComposeViewControllerDelegate {
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let iTunesLink = NSString(string: "") // Link to iTune App link, 在parse上留个接口
        let contectString = "Glad to meet you! My Bizid is " + ParseHelper.currentUser().email! + " Keep in touch!"
        let content = NSString(string: contectString)
        let name = NSString(string: "Yuan")
        let messageBody = "<br /><b>hello ,</b><br /><br />\(content) <br /><br /><b>Best regards,</b><br /><b>\(name)</b><br /><br /><b>Sent using <a href = '\(iTunesLink)'>Bizid</a> for the iPhone.</p></b>"
        mailComposerVC.setSubject("\(name) - sent using Bizid")
        mailComposerVC.setMessageBody(messageBody, isHTML: true)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value {
        case MFMailComposeResultSent.value:
            println("sent")
        case MFMailComposeResultCancelled.value:
//            mailComposerVCHandler = MFMailComposeViewController()
            println("cancel")
        case MFMailComposeResultSaved.value:
//            mailComposerVCHandler = controller
            println("saved")
        case MFMailComposeResultFailed.value:
            println("failed")
        default:break
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}