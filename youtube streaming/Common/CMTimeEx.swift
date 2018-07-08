//
//  CMTimeEx.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/8/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import CoreMedia

extension CMTime {
    var text:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
