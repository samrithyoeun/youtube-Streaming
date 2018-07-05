//
//  CustomTabBar.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
@IBDesignable
class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 40
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        backgroundColor = UIColor.black
        
        let tabBarItems = items! as [UITabBarItem]
        tabBarItems[0].title = nil
        tabBarItems[0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        return sizeThatFits
    }
}
