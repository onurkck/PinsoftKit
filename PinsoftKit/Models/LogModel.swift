//
//  LogModel.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import Foundation

class LogModel: NSObject, Codable {
    var screenName: String?
    var screenLogs: [ScreenLog] = [ScreenLog]()
    
    override init() {
        super.init()
    }
}
