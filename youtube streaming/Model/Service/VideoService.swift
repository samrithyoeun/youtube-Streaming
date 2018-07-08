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
    typealias ResponsedVideo = ((_ videos: [VideoEntity] ) -> ())
    typealias ResponsedImage = ((_ image: UIImage? ) -> ())
    typealias ResponsedString = ((_ stirng: String) -> ())
    
    static func get(callback: @escaping ResponsedVideo) {
        let url = ServerEnvironment.youtube
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let videoList = map(json)
                callback(videoList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func map(_ value: JSON) -> [VideoEntity] {
        var videos = [VideoEntity]()
        if let items = value["items"].array {
            for item in items {
                if let title = item["snippet"]["title"].string , let channel = item["snippet"]["channelTitle"].string , let videoId = item["id"]["videoId"].string , let thumbnail = item["snippet"]["thumbnails"]["medium"]["url"].string {
                    videos.append(VideoEntity(title: title, channel: channel, id: videoId, thumbnail: thumbnail))
                    
                }
            }
        }
        return videos
    }
    
    static func getImage(from imageURL: URL, callback: @escaping ResponsedImage ){
        Alamofire.request(imageURL)
            .validate()
            .responseData { (response) in
                if response.error == nil {
                    if let data = response.data{
                        let image = UIImage(data:data)
                        callback(image)
                    }
                }
        }
    }
    
    static func getSourceURL(id: String, callback: @escaping ResponsedString){
        if let url = URL(string: "https://www.youtube.com/watch?v="+id) {
            YoutubeSourceParser.h264videos(withYoutubeURL: url, completion: { (videoInfo, error) in
                guard let videoInfo = videoInfo else { return; }
                let videoInfoQualityMedium = videoInfo["medium"] as? [String: Any]
              
                if let qualityMediumURL = videoInfoQualityMedium?["url"] as? String {
                    print(" video link : \(qualityMediumURL) \n")
                    callback(qualityMediumURL)
                }

            })
        }
    }
}
