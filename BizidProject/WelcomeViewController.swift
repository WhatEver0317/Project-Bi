//
//  WelcomeViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/7.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK: - Override Methods
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
