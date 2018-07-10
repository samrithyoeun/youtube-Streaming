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

class VideoPlayerViewController: UIViewController {
    
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
    var offlinePlaying = false
    var indexOfPlayingVideo = 0
    var playerItem: AVPlayerItem?
    static var firstTimeSetup =  true
    var url: URL?
    private var playerItemContext = 0
    static let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if VideoPlayerViewController.firstTimeSetup == true {
            setUpUI()
            VideoPlayerViewController.firstTimeSetup = false
            playBackControll(indexOfPlayingVideo)
        } else {
            playBackControll(indexOfPlayingVideo)
        }
        
        
    }
    
    @IBAction func timelineSliderDidDragged(_ sender: UISlider) {
        VideoPlayerViewController.playerViewController.player?.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    @IBAction func volumnSliderValueChanged(_ sender: UISlider) {
        VideoPlayerViewController.playerViewController.player?.volume = sender.value
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if videoIsPlaying == true {
            print("video will be pause")
            VideoPlayerViewController.playerViewController.player?.pause()
            playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        } else {
            print("video will be play")
            VideoPlayerViewController.playerViewController.player?.play()
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
        performSegueToReturnBack()
    }
    
    func setUpUI(){
        timelineSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        volumnSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        self.present(VideoPlayerViewController.playerViewController, animated: true, completion: nil)
        
    }
}

extension VideoPlayerViewController {
    
    func playBackControll(_ index: Int){
        VideoPlayerViewController.playerViewController.player?.pause()
        videoIsPlaying = false
        playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        prepareToPlay(videos[index])
    }
    
    func prepareToPlay(_ video: VideoEntity){
        
        titleLabel.text = video.title
        channelLabel.text = video.channel
        currentTimeLabel.text = "NaN"
        durationLabel.text = "NaN"
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        videoIsPlaying = true
        VideoPlayerViewController.playerViewController.showsPlaybackControls = false
        self.addChildViewController(VideoPlayerViewController.playerViewController)
        self.videoPlayerView.addSubview((VideoPlayerViewController.playerViewController.view)!)
        VideoPlayerViewController.playerViewController.didMove(toParentViewController: self)
        VideoPlayerViewController.playerViewController.view.frame = self.videoPlayerView.bounds
        
        if offlinePlaying == true {
            guard let path = Bundle.main.path(forResource: video.videoLink, ofType:"mp4") else {
                debugPrint("debug: file not found")
                return
            }
            print("playing offline video")
            VideoPlayerViewController.playerViewController.player = AVPlayer(url: URL(fileURLWithPath: path))
            VideoPlayerViewController.playerViewController.player?.play()
            setupTimeLine()
        } else {
            VideoService.getSourceURL(id: videos[indexOfPlayingVideo].id) { (link) in
                let streamURL = URL(string: link)
                VideoPlayerViewController.playerViewController.player = AVPlayer(url: streamURL!)
                VideoPlayerViewController.playerViewController.player?.play()
                self.setupTimeLine()
            }
            
        }
    }
    
    func setupTimeLine() {
        print("debug: set up timeline")
        guard let currentItem = VideoPlayerViewController.playerViewController.player?.currentItem
            else {
                print("currentItem is nil in setupTimeLine")
                return
            }
        
        self.timelineSlider.maximumValue = Float(currentItem.asset.duration.seconds)
        self.timelineSlider.minimumValue = 0
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        VideoPlayerViewController.playerViewController.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { time in
            guard let currentItem = VideoPlayerViewController.playerViewController.player?.currentItem else {return}
            
            
            self.timelineSlider.value = Float(currentItem.currentTime().seconds)
            self.currentTimeLabel.text = currentItem.currentTime().text
            self.durationLabel.text = currentItem.duration.text
            
        })
    }
}
