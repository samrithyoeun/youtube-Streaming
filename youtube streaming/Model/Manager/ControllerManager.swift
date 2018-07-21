//
//  PlayerManger.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/10/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

class ControllerManager  {
    
    static let shared = ControllerManager()
    var videoPlayer: VideoPlayerViewController?
    var offlineVideo: OfflineVideoViewController?
    var videoTable: VideoTableViewController?

}
