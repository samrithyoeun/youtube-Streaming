//
//  FirstViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip

class FirstViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        APIRequest.get { json, code, error in print("\(json) \(code) \(error)") }
        
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "video view controller")
        let videoVC1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "video view controller")
        return [videoVC,videoVC1,videoVC1]

    }
    
    func setUpUI(){
        settings.style.buttonBarBackgroundColor = .black
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.selectedBarHeight = 2
        
        settings.style.buttonBarItemBackgroundColor = .black
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18)
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .red
        }
    }
    

}

