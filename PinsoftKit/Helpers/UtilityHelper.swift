//
//  UtilityHelper.swift
//  PinsoftKit
//
//  Created by Onur Küçük on 27.04.2022.
//

import Foundation
import UIKit

class UtilityHelper: NSObject {
    
    static func getAppName() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    static func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static func getOSVersion() -> String? {
        return UIDevice.current.systemVersion
    }
    
    static func getDeviceId() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    static func getScreenSize() -> CGRect {
        return UIScreen.main.bounds
    }
    
    static func getDeviceModel() -> String? {
        return UIDevice.current.type.rawValue
    }
    
    static func getIPAddress() -> String? {
        var address = ""
        let dict = NSMutableDictionary()
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "" }
        guard let firstAddr = ifaddr else { return "" }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            let interface = ptr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        dict.setValue(address, forKey: String(cString: interface.ifa_name))
                    }
                }
            }
        }
        if let ip = dict.object(forKey: "en0") {
            address = ip as! String
        }
        else if let ip = dict.object(forKey: "pdp_ip0") {
            address = ip as! String
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    static func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.GeneralDateFormatWithSecond
        return dateFormatter.string(from: Date())
    }
    
    static func isPortrait() -> Bool {
        return UIWindow.isPortrait
    }
}
