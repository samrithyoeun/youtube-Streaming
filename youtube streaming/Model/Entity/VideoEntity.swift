//
//  VideoEntity.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
class VideoEntity{
    var title = ""
    var channel = ""
    var id = ""
    var thumbnail = ""
    var videoLink = ""

    init(title: String, channel: String, id: String, thumbnail: String, videoLink: String = ""){
        self.title = title
        self.channel = channel
        self.thumbnail = thumbnail
        self.id = id
        VideoService.getSourceURL(id: id) { (link) in
            self.videoLink = link
        }
    }
    
    init() {}
}

