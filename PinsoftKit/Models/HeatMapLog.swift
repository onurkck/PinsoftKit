//
//  HeatMapLog.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import Foundation

struct HeatMapLog: Codable {
    var screenName: String
    var isPortrait: Bool
    var clickTime: String
    var xPoint: Int
    var yPoint: Int
}
