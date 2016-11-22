//
//  ApptResponse.swift
//  MyCalendarApp
//
//  Created by Bill McCoy on 11/22/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Appt: Mappable {
    var StartTime: String?
    var EndTime: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        StartTime <- map["StartTime"]
        EndTime <- map["EndTime"]
    }
}

