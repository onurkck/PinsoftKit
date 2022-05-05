//
//  LogHelper.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import Foundation
import UIKit

class LogHelper: NSObject {
    
    static let shared = LogHelper()
    static let LogBatchKey = "LOGBATCH"
    private let LastKnownVCKey = "LAST_KNOWN_VC_NAME"
    
    override init() {
        super.init()
    }
    
    static func getLogBatch() -> LogBatch?{
        if let data = UserDefaults.standard.data(forKey: LogBatchKey), let logBatch = DataHelper.decode(from: data) {
            return logBatch
        }else {
            return nil
        }
    }
    
    static func set(logBatch: LogBatch){
        if let data  = DataHelper.encode(from: logBatch) {
            UserDefaults.standard.set(data, forKey: LogBatchKey)
        }
    }
    
    static func setLastKnown(vcName: String) {
        UserDefaults.standard.setValue(vcName, forKey: LogHelper.shared.LastKnownVCKey)
    }
    
    static func getLastKownVC() -> String {
        if let vcName = UserDefaults.standard.value(forKey: LogHelper.shared.LastKnownVCKey) as? String {
            return vcName
        }
        return ""
    }
    
}

