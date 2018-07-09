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
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var videos = [VideoEntity]()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var videoIsPlaying = false
    var indexOfPlayingVideo = 0
    var playerItem: AVPlayerItem?
    var url: URL?
    var asset: AVAsset?
    let requiredAssetKeys = ["playable", "hasProtectedContent"]
    private var playerItemContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineSlider.setThumbImage(#imageLiteral(resourceName: "circle"), for: .normal)
        prepareToPlay(videos[indexOfPlayingVideo])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = self.videoPlayerView.bounds
    }
    
    @IBAction func timelineSliderDidDragged(_ sender: UISlider) {
        currentTimeLabel.text = String(sender.value)
        player?.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if videoIsPlaying == true {
            print("video will be pause")
            player?.pause()
            playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        } else {
            print("video will be play")
            player?.play()
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

    @IBAction func backButtonTapped(_ sender: Any) {
        player?.pause()
        self.dismiss(animated: true, completion: {})
    }
}

extension VideoPlayerVC {
    // Mark: - AVPlayer Method
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = self.player?.currentItem?.duration.text
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                print("player: ready")
                currentTimeLabel.text = self.player?.currentTime().text
                durationLabel.text = self.player?.currentItem?.duration.text
                player?.play()
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.videoGravity = .resize
                videoPlayerView.layer.addSublayer(playerLayer!)
                player?.play()
                videoIsPlaying = true
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                
            case .failed:
                print("player: fail")
                self.player?.pause()
            case .unknown:
                print("player: unknown")
            }
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player?.currentItem else {return}
            self?.timelineSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timelineSlider.minimumValue = 0
            self?.timelineSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.player?.currentItem?.currentTime().text
        })
    }
    
    private func playBackControll(_ index: Int){
        player?.pause()
        videoIsPlaying = false
        playButton.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        videoPlayerView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        prepareToPlay(videos[index])
        
    }
    
    private func prepareToPlay(_ video: VideoEntity){
        titleLabel.text = video.title
        channelLabel.text = video.channel
        currentTimeLabel.text = "NaN"
        durationLabel.text = "NaN"
        loadingIndicator.startAnimating()
        VideoService.getSourceURL(id: video.id) { (link) in
            
            let url = URL(string: link)
            self.asset = AVAsset(url: url!)
            
            self.playerItem = AVPlayerItem(asset: self.asset!,
                                           automaticallyLoadedAssetKeys: self.requiredAssetKeys)
            
            self.playerItem?.addObserver(self,
                                         forKeyPath: #keyPath(AVPlayerItem.status),
                                         options: [.old, .new],
                                         context: &self.playerItemContext)
            
            self.player = AVPlayer(playerItem: self.playerItem)
            
        }
    }
}

protocol ModalViewControllerDelegate:class {
    func dismissed()
}

