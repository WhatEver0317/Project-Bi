//
//  DetailTableViewCell.swift
//  BizidProject
//
//  Created by GaoYuan on 15/9/24.
//  Copyright (c) 2015年 Yuan Gao. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.valueLabel.becomeFirstResponder()
        let tapGesture = UILongPressGestureRecognizer(target: self, action: "handleTapGesture:")
        self.valueLabel.addGestureRecognizer(tapGesture)
    }
    
    // Copy text
    func handleTapGesture(gestureRecognizer: UILongPressGestureRecognizer)
    {
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = valueLabel.text
        GlobalHUD.showErrorHUDForView(self.superview, withMessage: "Copied!", animated: true, hide: true, delay: 1)
    }

}
