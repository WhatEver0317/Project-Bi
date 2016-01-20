//
//  GlobalHUD.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/10.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class GlobalHUD: MBProgressHUD {

    class func showLoginHUDAddedToView(view:UIView!, animated:Bool)
    {
        var loginHUD = MBProgressHUD(view: view)
        loginHUD.removeFromSuperViewOnHide = true
        view.addSubview(loginHUD)
        loginHUD.labelText = "Logging in..."
        loginHUD.show(animated)
    }
    
    class func hideLoginHUDForView(view:UIView!, animated:Bool)
    {
        MBProgressHUD.hideHUDForView(view, animated: animated)
    }
    
    class func showErrorHUDForView(view:UIView!, withMessage message:String?, animated:Bool, hide:Bool, delay:NSTimeInterval)
    {
        var errorHUD = MBProgressHUD(view: view)
        errorHUD.removeFromSuperViewOnHide = true
        errorHUD.mode = MBProgressHUDMode.CustomView
        view.addSubview(errorHUD)
        errorHUD.labelText = message
        errorHUD.show(animated)
        errorHUD.hide(hide, afterDelay: delay)
    }

}
