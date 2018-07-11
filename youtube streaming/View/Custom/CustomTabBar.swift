//
//  CustomTabBar.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 40
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        backgroundColor = UIColor.black
        return sizeThatFits
    }
    
}
