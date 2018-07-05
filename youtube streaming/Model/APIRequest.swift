//
//  APIRequest.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIRequest {
     typealias RestResponse = ((_ response: JSON, _ responseCode: Int?, _ error: Error?) -> ())
    
    static func get(endPoint: String = "", headers: [String: String] = [:], parameters: Parameters = [:], callback: @escaping RestResponse) {
        
        let url = ServerEnvironment.youtube + endPoint
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseString(encoding: .utf8) { (response: DataResponse<String>) in
                handle(response: response, responseCode: response.response?.statusCode, callback: callback)
        }
    }
    
    static func getImage(from imageURL: URL, callback: @escaping (UIImage?)->() ){
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
    
    static func map(_ value: JSON) -> [VideoEntity] {
        var videos = [VideoEntity]()
        if let items = value["items"].array {
            for item in items {
                let title = item["snippet"]["title"].string!
                let channel = item["snippet"]["channelTitle"].string!
                let videoId = item["id"]["videoId"].string!
                let thumbnail = item["snippet"]["thumbnails"]["medium"]["url"].string!
                videos.append(VideoEntity(title: title, channel: channel, videoId: videoId, thumbnail: thumbnail))
            }
        }
        return videos
    }
    
    private static func handle(response: DataResponse<String>, responseCode: Int?, callback: RestResponse) {
        guard let resultValue = response.value else {
            callback(JSON.null, responseCode, response.error)
            return
        }
        let json = JSON(parseJSON: resultValue)
        
        callback(json, responseCode, response.error)
    }

}

