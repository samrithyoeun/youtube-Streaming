//
//  FirstViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//
import UIKit
import AVFoundation
import AVKit

class VideoPlayerVC: UIViewController {
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var volumnSlider: UISlider!
    var videos = [VideoEntity]()
    var player = AVPlayer()
    var videoIsPlaying = false
    var indexOfPlayingVideo = 0
    var playerItem: AVPlayerItem?
    var url: URL?
    private var playerItemContext = 0
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        prepareToPlay(videos[indexOfPlayingVideo])
    }
    
    @IBAction func timelineSliderDidDragged(_ sender: UISlider) {
      //  currentTimeLabel.text = player.currentTime().text
      //  player?.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    @IBAction func volumnSliderValueChanged(_ sender: UISlider) {
        playerViewController.player?.volume = sender.value
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if videoIsPlaying == true {
            print("video will be pause")
            playerViewController.player?.pause()
            playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        } else {
            print("video will be play")
            playerViewController.player?.play()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        videoIsPlaying = !videoIsPlaying
        
    }
    
    @IBAction func nextButtonTapeed(_ sender: Any) {
        if indexOfPlayingVideo == videos.count-1 {
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

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
   
    private func setUpUI(){
         timelineSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        
    }
}

extension VideoPlayerVC {
    // Mark: - AVPlayer Method
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            self?.timelineSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timelineSlider.minimumValue = 0
            self?.timelineSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.player.currentItem?.currentTime().text
        })
    }
    
    private func playBackControll(_ index: Int){
        playerViewController.player?.pause()
        videoIsPlaying = false
        playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        prepareToPlay(videos[index])
    }

    private func prepareToPlay(_ video: VideoEntity){
       
        titleLabel.text = video.title
        channelLabel.text = video.channel
        currentTimeLabel.text = "NaN"
        durationLabel.text = "NaN"
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        videoIsPlaying = true
        playerViewController.showsPlaybackControls = false
        self.addChildViewController(playerViewController)
        self.videoPlayerView.addSubview((playerViewController.view)!)
        playerViewController.didMove(toParentViewController: self)
        playerViewController.view.frame = self.videoPlayerView.bounds
        
        VideoService.getSourceURL(id: videos[indexOfPlayingVideo].id) { (link) in
            let streamURL = URL(string: link)
            self.playerViewController.player = AVPlayer(url: streamURL!)
            self.playerViewController.player?.play()
    }
}

}
