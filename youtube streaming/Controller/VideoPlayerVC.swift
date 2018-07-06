//
//  FirstViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerVC: UIViewController {
    @IBOutlet weak var videoPlayerView: YouTubePlayerView!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playingLabel: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    var video = VideoEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if videoPlayerView.ready {
            print("playing video")
            videoPlayerView.loadVideoID(video.videoId)
            videoPlayerView.play()
        }
    }
    
    
    
}

