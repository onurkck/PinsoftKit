//
//  ScreenLog.swift
//  PSKitPlayground
//
//  Created by Onur Küçük on 11.04.2022.
//

import Foundation

class ScreenLog: NSObject, Codable {
    var screenName: String?
    var startTime: String?
    var endTime: String?
    var screenHeatMapPoints: [HeatMapLog]?
    
    override init() {
        super.init()
    }
}
