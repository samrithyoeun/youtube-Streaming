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
    
    let indicator: AudioIndicatorBarsView = AudioIndicatorBarsView(CGRect(x: 0, y: 0, width: 30, height: 30),6,5,.orange)
    var firstTimePresentPlayer = true
    var videos: [VideoEntity] = {
            var videos = [VideoEntity]()
            videos.append(VideoEntity(title: "Upbeat music", channel: "localfile", id: "", thumbnail: "upbeat", videoLink: "upbeat"))
            videos.append(VideoEntity(title: "UpLift music", channel: "localfile", id: "", thumbnail: "uplifted", videoLink: "uplift"))
            videos.append(VideoEntity(title: "Hppy Upbeat music", channel: "localfile", id: "", thumbnail: "happy", videoLink: "happy"))
            return videos
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ControllerManager.shared.offlineVideo = self
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ControllerManager.shared.videoPlayer?.videoIsPlaying == true {
            indicator.start()
        } else {
            indicator.stop()
        }
        refreshUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoPlayerVC = segue.destination as? VideoPlayerViewController, let cell = sender as? UITableViewCell{
            if let index = tableView.indexPath(for: cell){
                videoPlayerVC.videos = videos
                videoPlayerVC.indexOfPlayingVideo = index.row
                videoPlayerVC.offlinePlaying = true
                ControllerManager.shared.videoPlayer = videoPlayerVC
                if firstTimePresentPlayer == true {
                    firstTimePresentPlayer = false
                    ControllerManager.shared.videoPlayer = videoPlayerVC
                }
                indicator.start()
            }
        }
    }
    
    public func refreshUI(){
        print("refresh ui in OfflineView")
        print("offline".localized())
        self.navigationItem.title = "offline".localized()
    }
    
    private func setupUI() {
        let mview = UIView()
        mview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mview.addSubview(indicator)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mview)
        navigationItem.rightBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popBackToPlayer(_:))))
    }
    
    @objc private func popBackToPlayer(_ button:UIBarButtonItem) {
        self.present(ControllerManager.shared.videoPlayer!, animated: true, completion: nil)
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
