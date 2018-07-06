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
            segmentControl?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
            segmentControl?.addTarget(self, action: #selector(SecondViewController.changedControl), for: UIControlEvents.valueChanged)
            segmentControl?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
            segmentControl?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
            segmentControl?.backgroundColor = UIColor.black
            segmentControl?.isVerticalDividerEnabled = true
            segmentControl?.verticalDividerColor = UIColor.red
            segmentControl?.verticalDividerWidth = 1.0
        
            self.headerView.addSubview(segmentControl!)
        
    }
    
    @objc func changedControl(){
        
    }
}

