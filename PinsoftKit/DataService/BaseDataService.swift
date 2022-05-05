//
//  BaseDataService.swift
//  PinsoftKit
//
//  Created by Onur Küçük on 27.04.2022.
//

import UIKit
import Foundation

class BaseDataService: NSObject {
    private var request: URLRequest?
    
    override init() {
    }
    
    func set(endPoint: String, method: RequestMethod) {
        if let requestURL = URL(string: "\(Constants.BaseURL)\(endPoint)") {
            request = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60*60)
            request?.httpMethod = method.rawValue
            
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.addValue("Apple", forHTTPHeaderField: "deviceBrand")
            request?.addValue(UtilityHelper.getDeviceId() ?? "", forHTTPHeaderField: "deviceId")
            request?.addValue(UtilityHelper.getIPAddress() ?? "", forHTTPHeaderField: "ipAddress")
            request?.addValue(UIDevice.current.type.rawValue, forHTTPHeaderField: "Content-Type")
            request?.addValue("IOS", forHTTPHeaderField: "os")
            request?.addValue(UtilityHelper.getOSVersion() ?? "", forHTTPHeaderField: "osVersion")
        }
    }
    
    func startRequest(with data: Data?, onSuccess: @escaping (_ decodableData: Data) -> Void, onFailure: @escaping (_ error: String) -> Void) {
        if var req = request {
            req.httpBody = data
            let session = URLSession.shared
            session.dataTask(with: req) { responseData, response, error in
                if let err = error {
                    onFailure(err.localizedDescription)
                    print(err.localizedDescription)
                }
                if let res = response as? HTTPURLResponse{
                    if res.statusCode != 200 {
                        onFailure("Fail with status code: \(res.statusCode)")
                    }
                }
                if let resData = responseData {
                    onSuccess(resData)
                }
            }.resume()
        }
    }
}

enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}
