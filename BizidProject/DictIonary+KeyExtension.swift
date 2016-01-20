//
//  Dictory+KeyExtension.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/11.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

extension Dictionary {
    func getFirstKey() -> String?
    {
        var myKey:String = ""
        for key in self.keys{
            myKey = String(stringInterpolationSegment: key)
        }
        return myKey
    }
}