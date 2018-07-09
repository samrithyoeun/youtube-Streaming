//
//  VideoTableVC.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import AudioIndicatorBars

class VideoTableViewController: UIViewController {
    
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [VideoEntity]()
    var videoPlayerViewController: VideoPlayerViewController?
    var firstTimePresentPlayer = true
    
    let indicator: AudioIndicatorBarsView = AudioIndicatorBarsView(CGRect(x: 0, y: 0, width: 30, height: 30),6,5,.orange)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        VideoService.get { (videos) in
            self.videos = videos
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstTimePresentPlayer == false {
            if videoPlayerViewController?.videoIsPlaying == false {
                indicator.stop()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoPlayerVC = segue.destination as? VideoPlayerViewController, let cell = sender as? UITableViewCell{
            if let index = tableView.indexPath(for: cell){
                videoPlayerVC.videos = videos
                videoPlayerVC.indexOfPlayingVideo = index.row
                self.videoPlayerViewController = videoPlayerVC
                if firstTimePresentPlayer == true {
                    firstTimePresentPlayer = false
                    self.videoPlayerViewController = videoPlayerVC
                }
                indicator.start()
            }
        }
    }
    
    func setUpUI(){
        let segmentControl = HMSegmentedControl(sectionTitles: ["NEW-HITS" ,"HOTTEST", "JUST-IN"])
        segmentControl?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
        segmentControl?.addTarget(self, action: #selector(VideoTableViewController.changedControl), for: UIControlEvents.valueChanged)
        segmentControl?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentControl?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentControl?.backgroundColor = UIColor.black
        segmentControl?.isVerticalDividerEnabled = true
        segmentControl?.verticalDividerColor = UIColor.orange
        segmentControl?.verticalDividerWidth = 1.0
        segmentControl?.selectionIndicatorColor = UIColor.orange
        
        segmentControl?.titleFormatter = { segmentedControl, title, index, selected in
            let attString = NSAttributedString(string: title ?? "", attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey as NSAttributedStringKey: UIColor.white])
            return attString
            
        }
        self.segmentView.addSubview(segmentControl!)
        
        let mview = UIView()
        mview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mview.addSubview(indicator)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mview)
        navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popBackToPlayer(_:))))
    }
    
    @objc func changedControl(){
        
    }
    
    @objc func popBackToPlayer(_ button:UIBarButtonItem) {
        self.present(videoPlayerViewController!, animated: true, completion: nil)
        print("hell")
    }
}

extension VideoTableViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}

extension VideoTableViewController: UITableViewDataSource {
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


