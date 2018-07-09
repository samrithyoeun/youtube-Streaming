//
//  VideoTableViewCell.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func bindData(with video: VideoEntity){
        VideoService.getImage(from: URL(string: video.thumbnail)!) { (image) in
            self.videoImageView.image = image!
            
        }
        channelLabel.text = video.channel
        titleLabel.text = video.title
        
    }
}
