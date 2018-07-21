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
import Localize_Swift

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var volumnSlider: UISlider!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    
    var videos = [VideoEntity]()
    var originalVideos = [VideoEntity]()
    var player = AVPlayer()
    var videoIsPlaying = false
    var offlinePlaying = false
    var shuffleState = false
    var loopState = false
    var indexOfPlayingVideo = 0
    var playerItemContext = 0
    var playerItem: AVPlayerItem?
    var url: URL?
    
    static let playerViewController = AVPlayerViewController()
    static var firstTimeSetup =  true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalVideos = videos
        
        if VideoPlayerViewController.firstTimeSetup == true {
            setUpUI()
            self.setupNotification()
            VideoPlayerViewController.firstTimeSetup = false
            playBackControll(indexOfPlayingVideo)
        } else {
            playBackControll(indexOfPlayingVideo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    @IBAction func loopButtonDidTouched(_ sender: Any) {
        if loopState == false {
            loopState = true
            loopButton.setImage(#imageLiteral(resourceName: "repeat"), for: .normal)
        } else {
            loopState = false
            loopButton.setImage(#imageLiteral(resourceName: "reapeat-off"), for: .normal)
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
        playBackControll(indexOfNextVideoToPlay())
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        playBackControll(IndexOfPreviousVideoToPlay())
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shuffleButtonDidTouched(_ sender: Any) {
        if shuffleState == false {
            videos.shuffle()
            shuffleState = true
            shuffleButton.setImage(#imageLiteral(resourceName: "shuffle"), for: .normal)
        } else {
            shuffleButton.setImage(#imageLiteral(resourceName: "shuffle-off"), for: .normal)
            shuffleState = false
        }
    }
    
    public func refreshUI(){
        print("refresh ui in VideoPlayer")
        print("now-playing".localized())
        nowPlayingLabel.text = "now-playing".localized()
    }
    
    private func setUpUI(){
        timelineSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        volumnSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        self.present(VideoPlayerViewController.playerViewController, animated: true, completion: nil)
    }

}

extension VideoPlayerViewController {
    //Mark: - AVPLayer methods
    private func indexOfNextVideoToPlay() -> Int {
        if indexOfPlayingVideo == videos.count-1 {
            indexOfPlayingVideo = 0
        } else {
            indexOfPlayingVideo += 1
        }
        return indexOfPlayingVideo
    }
    
    private func IndexOfPreviousVideoToPlay() -> Int {
        if indexOfPlayingVideo == 0 {
            indexOfPlayingVideo = videos.count - 1
        } else {
            indexOfPlayingVideo -= 1
        }
        return indexOfPlayingVideo
    }
    
    func playBackControll(_ index: Int){
        VideoPlayerViewController.playerViewController.player?.pause()
        videoIsPlaying = false
        playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        if shuffleState == true {
            prepareToPlay(videos[index])
        } else {
            prepareToPlay(originalVideos[index])
        }
        
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
            self.setupTimeLine()
            
        } else {
            VideoService.getSourceURL(id: videos[indexOfPlayingVideo].id) { (result) in
                switch result {
                case .success(let link):
                    let streamURL = URL(string: link)
                    VideoPlayerViewController.playerViewController.player = AVPlayer(url: streamURL!)
                    VideoPlayerViewController.playerViewController.player?.play()
                    self.setupTimeLine()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc private func finishVideo()
    {
        if loopState == true {
            playBackControll(indexOfPlayingVideo)
        } else {
            playBackControll(indexOfNextVideoToPlay())
        }
    }
    
    private func setupTimeLine() {
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
            self.durationLabel.text = currentItem.asset.duration.text
            
        })
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: VideoPlayerViewController.playerViewController.player?.currentItem)
    }
    
}
