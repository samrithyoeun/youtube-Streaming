//
//  OfflineVideoTableViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/9/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import AudioIndicatorBars

class OfflineVideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = VideoEntity.getOfflineVideo()
    var videoPlayerViewController: VideoPlayerViewController?
    var firstTimePresentPlayer = true
    
    let indicator: AudioIndicatorBarsView = AudioIndicatorBarsView(CGRect(x: 0, y: 0, width: 30, height: 30),6,5,.orange)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoPlayerVC = segue.destination as? VideoPlayerViewController, let cell = sender as? UITableViewCell{
            if let index = tableView.indexPath(for: cell){
                videoPlayerVC.videos = videos
                videoPlayerVC.indexOfPlayingVideo = index.row
                videoPlayerVC.offlinePlaying = true
                self.videoPlayerViewController = videoPlayerVC
                if firstTimePresentPlayer == true {
                    firstTimePresentPlayer = false
                    self.videoPlayerViewController = videoPlayerVC
                }
                indicator.start()
            }
    }
}
    
    private func setupUI(){
        let mview = UIView()
        mview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mview.addSubview(indicator)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mview)
        navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popBackToPlayer(_:))))
    }
    
    @objc func popBackToPlayer(_ button:UIBarButtonItem) {
        self.present(videoPlayerViewController!, animated: true, completion: nil)
    }
}

extension OfflineVideoViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}

extension OfflineVideoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "offline cell")  as! OfflineVideoTableViewCell
        cell.bindWith(video)
        return cell
    }
}
