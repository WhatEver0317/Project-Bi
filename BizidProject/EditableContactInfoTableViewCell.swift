//
//  EditableContactInfoTableViewCell.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/26.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class EditableContactInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
