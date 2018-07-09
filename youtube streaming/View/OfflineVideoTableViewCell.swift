//
//  OfflineVideoTableViewCell.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/9/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class OfflineVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func bindWith(_ video: VideoEntity){
        titleLabel.text = video.title
        
    }
}
