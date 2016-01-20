//
//  NSError+Message.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/14.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//


extension NSError {
    func message() -> String
    {
        return userInfo?["error"] as! String
    }
}