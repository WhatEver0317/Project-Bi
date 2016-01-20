//
//  SharedViewController.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/9.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupGesture()
    {
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissKeyboard)
    }

}
