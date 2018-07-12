//
//  ArrayEx.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/10/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

extension Array
{
    mutating func shuffle() {
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
}

