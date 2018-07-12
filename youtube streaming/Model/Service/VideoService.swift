//
//  VideoService.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/7/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VideoService {
    
    typealias ResponsedVideo = ((_ videos: Result<[VideoEntity]> ) -> ())
    typealias ResponsedImage = ((_ image: Result<UIImage?> ) -> ())
    typealias ResponsedString = ((_ stirng: Result<String>) -> ())
    
    static func get(callback: @escaping ResponsedVideo) {
        let header = APIHeader.getAuthorizationVideo()
        APIRequest.get(endPoint: "", headers: header) { (response: JSON, responseCode: Int?, error: Error?) in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                callback(Result.failure("Cannot get videos from API"))
                return
            }
            
            callback(Result.success(self.map(response)))
            
        }
    }
    
    static func map(_ value: JSON) -> [VideoEntity] {
        var videos = [VideoEntity]()
        if let items = value["items"].array {
            for item in items {
                if let title = item["snippet"]["title"].string , let channel = item["snippet"]["channelTitle"].string , let videoId = item["id"]["videoId"].string , let thumbnail = item["snippet"]["thumbnails"]["medium"]["url"].string {
                    videos.append(VideoEntity(title: title, channel: channel, id: videoId, thumbnail: thumbnail, videoLink: ""))
                    
                }
            }
        }
        return videos
    }
    
    
    static func getSourceURL(id: String, callback: @escaping ResponsedString){
        if let url = URL(string: "https://www.youtube.com/watch?v="+id) {
            YoutubeSourceParser.h264videos(withYoutubeURL: url, completion: { (videoInfo, error) in
                guard let videoInfo = videoInfo else { return; }
                let videoInfoQualityMedium = videoInfo["medium"] as? [String: Any]
              
                if let qualityMediumURL = videoInfoQualityMedium?["url"] as? String {
                    callback(Result.success(qualityMediumURL))
                } else {
                    callback(Result.failure("cannot get url"))
                }

            })
        }
    }
}
