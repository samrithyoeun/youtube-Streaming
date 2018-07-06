//
//  VideoTableVC.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoTableVC: UIViewController {
    
   
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [VideoEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpUI()
        APIRequest.get { (json, code, error) in
            self.videos = APIRequest.map(json)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoPlayerVC = segue.destination as? VideoPlayerVC, let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                videoPlayerVC.video = videos[indexPath.row]
            }
        }
    }
    
    func setUpUI(){
        let segmentControl = HMSegmentedControl(sectionTitles: ["NEW-HITS" ,"HOTTEST", "JUST-IN"])
        segmentControl?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        segmentControl?.addTarget(self, action: #selector(VideoTableVC.changedControl), for: UIControlEvents.valueChanged)
        segmentControl?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentControl?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentControl?.backgroundColor = UIColor.black
        segmentControl?.isVerticalDividerEnabled = true
        segmentControl?.verticalDividerColor = UIColor.red
        segmentControl?.verticalDividerWidth = 1.0
        segmentControl?.selectionIndicatorColor = UIColor.red
        
        segmentControl?.titleFormatter = { segmentedControl, title, index, selected in
            let attString = NSAttributedString(string: title ?? "", attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey as NSAttributedStringKey: UIColor.white])
            return attString
            
        }
        self.segmentView.addSubview(segmentControl!)
        
    }
   
    @objc func changedControl(){
        
    }
}

extension VideoTableVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension VideoTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "video tableview cell")  as! VideoTableViewCell
        cell.bindData(with: video)
        return cell
    }
}


