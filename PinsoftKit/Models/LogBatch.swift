//
//  LogBatch.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import Foundation

class LogBatch: NSObject, Codable {
    var deviceModel: String?
    var deviceId: String?
    var osVersion: String?
    var appName: String?
    var appVersion: String?
    var screenWidth: Int?
    var screenHeight: Int?
    var logModels: [LogModel] = [LogModel]()
    
    override init() {
        super.init()
    }
}
