//
//  DataHelper.swift
//  PinsoftKit
//
//  Created by Onur Küçük on 27.04.2022.
//

import Foundation
class DataHelper: NSObject {
    
    static func decode(from data: Data) -> LogBatch? {
        do {
            let decoder = JSONDecoder()
            let logBatch = try decoder.decode(LogBatch.self, from: data)
            return logBatch
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func encode(from logBatch: LogBatch) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(logBatch)
            return data
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func extractVCName(from className: String) -> String {
        if let index = className.firstIndex(where: {$0 == "."}) {
            let nextIndex = className.index(after: index)
            return String(className[nextIndex...])
        }
        return className
    }
    
}
