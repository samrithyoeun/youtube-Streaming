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
    @IBOutlet weak var playButton: UIButton!
    
    var video = VideoEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo(video.videoId)
        
    }
    
    func loadVideo(_ videoId: String){
        videoPlayerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
        videoPlayerView.loadVideoID(videoId)
        videoPlayerView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if videoPlayerView.ready {
            print("playing video")
            videoPlayerView.loadVideoID(video.videoId)
            videoPlayerView.play()
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if videoPlayerView.ready {
            if videoPlayerView.playerState != YouTubePlayerState.Playing {
                videoPlayerView.play()
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            } else {
                videoPlayerView.pause()
                playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
                let duration  = videoPlayerView.getDuration()
                print("duration : \(duration)")
            }
        }
    }
   
    @IBAction func nextButtonTapeed(_ sender: Any) {
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
    }
    
}


