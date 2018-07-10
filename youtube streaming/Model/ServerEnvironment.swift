//
//  ServerEnvironment.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
struct ServerEnvironment {
    #if DEV_ENVIRONMENT
    static let localIp = "http://192.168.168.168:8080"
    static let host = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=Khmer%20Song&key=AIzaSyAdyVbGpQ_4yKXRFpYfYjyH1Lhu95QD9iw&maxResults=20"
    #else
    static let localIp = "http://pathmazing.com"
    static let host = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=Khmer%20Song&key=AIzaSyAdyVbGpQ_4yKXRFpYfYjyH1Lhu95QD9iw&maxResults=20"
    #endif
}
