//
//  FirstViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//
import UIKit
import AVFoundation


class VideoPlayerVC: UIViewController {
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    
    var videos = [VideoEntity]()
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoIsPlaying = false
    var indexOfPlayingVideo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPlay(video: videos[0])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = self.videoPlayerView.bounds
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if videoIsPlaying == true {
            print("video will be pause")
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        } else {
            print("video will be play")
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        videoIsPlaying = !videoIsPlaying
    }
    
    @IBAction func nextButtonTapeed(_ sender: Any) {
        if indexOfPlayingVideo == videos.count {
            indexOfPlayingVideo = 0
        } else {
            indexOfPlayingVideo += 1
        }
       playBackControll(indexOfPlayingVideo)
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        if indexOfPlayingVideo == 0 {
            indexOfPlayingVideo = videos.count - 1
        } else {
            indexOfPlayingVideo -= 1
        }
       playBackControll(indexOfPlayingVideo)
    }
    
    func startPlay(video: VideoEntity){
        titleLabel.text = video.title
        channelLabel.text = video.channel
        
        let url = URL(string: video.videoLink)
        player = AVPlayer(url: url!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        videoPlayerView.layer.addSublayer(playerLayer)
        player.play()
        videoIsPlaying = true
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    }
    
    func playBackControll(_ index: Int){
        player.pause()
        videoIsPlaying = false
        playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        startPlay(video: videos[index])
        
        titleLabel.text = videos[index].title
        channelLabel.text = videos[index].channel
    }
}
