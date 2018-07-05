//
//  SecondViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpUI()
    }


    func setUpUI(){
        
            let segmentControl = HMSegmentedControl(sectionTitles: ["NEW-HITS" ,"HOTTEST", "JUST-IN"])
            segmentControl?.frame = CGRect(x: 0, y: 0, width: self.headerView.frame.width, height: 60)
            segmentControl?.addTarget(self, action: #selector(SecondViewController.changedControl), for: UIControlEvents.valueChanged)
            segmentControl?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
            segmentControl?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
            segmentControl?.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.137254902, blue: 0.1568627451, alpha: 1)
            segmentControl?.isVerticalDividerEnabled = true
            segmentControl?.verticalDividerColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.1529411765, alpha: 1)
            segmentControl?.verticalDividerWidth = 1.0
            self.headerView.addSubview(segmentControl!)
        
    }
    
    @objc func changedControl(){
        
    }
}

