//
//  VideoEntity.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
struct VideoEntity{
    var title = ""
    var channel = ""
    var videoId = ""
    var thumbnail = ""
    
    func getVideoURL() -> URL? {
        return URL(string: "https://youtu.be/\(videoId)")
    }
    
}
