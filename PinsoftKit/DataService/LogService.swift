//
//  LogService.swift
//  PSKit
//
//  Created by Onur Küçük on 11.04.2022.
//

import UIKit
import Foundation

class LogService: BaseDataService {
    
    let customLogEndPoint = ""
    let screenLogEndPoint = ""

    override init() {
        super.init()
    }
    
    func logScreenEvents(logBatch: LogBatch){
        //FIXME: - Send directly logBatch
        let configuredLogBatch = logBatch
        
        if let data = DataHelper.encode(from: configuredLogBatch) {
            let service = BaseDataService()
            service.set(endPoint: Constants.ScreenLogEndPoint, method: .post)
            
            service.startRequest(with: data) { decodableData in
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(GenericLogResponse.self, from: decodableData)
                    if response.isSuccess {
                        print("Screen logs saved")
                    }
                }
                catch {
                    print("Error occured during screen loging")
                }
                
            } onFailure: { error in
                print("Error occured during screen loging")
            }
        }
    }
    
    func logCustomEvent(name: String){
        
    }
}
