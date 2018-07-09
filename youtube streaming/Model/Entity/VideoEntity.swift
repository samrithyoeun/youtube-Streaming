//
//  VideoEntity.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

class VideoEntity {
    var title = ""
    var channel = ""
    var id = ""
    var thumbnail = ""
    var videoLink = ""
    

    init(title: String, channel: String, id: String, thumbnail: String, videoLink: String = ""){
       
        self.id = id
        self.title = title
        self.channel = channel
        self.thumbnail = thumbnail
        self.videoLink = videoLink
    }
    
    init() {}
    
    static func getOfflineVideo() -> [VideoEntity] {
        var videos = [VideoEntity]()
        videos.append(VideoEntity(title: "Upbeat music", channel: "localfile", id: "", thumbnail: "", videoLink: "/Users/pmacademy3/Documents/xiong/youtube streaming/youtube streaming/Supporting File/Videos/upbeat.mp4"))
        videos.append(VideoEntity(title: "UpLift music", channel: "localfile", id: "", thumbnail: "", videoLink: "/Users/pmacademy3/Documents/xiong/youtube streaming/youtube streaming/Supporting File/Videos/uplift.mp4"))
        videos.append(VideoEntity(title: "Hppy Upbeat music", channel: "localfile", id: "", thumbnail: "", videoLink: "/Users/pmacademy3/Documents/xiong/youtube streaming/youtube streaming/Supporting File/Videos/happy.mp4"))
        return videos
    }
    
}

