//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jose Sanchez on 10/5/15.
//  Copyright © 2015 Jose Sanchez. All rights reserved.
//

import Foundation

/*
 * Stores the params of the recorded audio
 */
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl:NSURL, title:String){
        self.title=title
        self.filePathUrl=filePathUrl
    }
}