//
//  NetworkLayer.swift
//  TestProjectMonyList
//
//  Created by Zimma on 05/09/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkLayer: NSObject {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    
    
    class func isInternetAvailable(webSiteToPing: String?, completionHandler: @escaping (Bool, String?) -> Void) {
        
        // 1. Check the WiFi Connection
        guard isConnectedToNetwork() else {
            completionHandler(false, "Отсутствует интернет соединение. Проверьте подключение и повторите попытку позже.")
            return
        }
        
        // 2. Check the Internet Connection
        var webAddress = "https://www.google.com" // Default Web Site
        if let _ = webSiteToPing {
            webAddress = webSiteToPing!
        }
        
        guard let url = URL(string: webAddress) else {
            print("could not create url from: \(webAddress)")
            completionHandler(false, "Сервер временно недоступен, повторите попытку позже.")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil || response == nil {
                completionHandler(false, "Сервер временно недоступен, повторите попытку позже.")
            } else {
                completionHandler(true, nil)
            }
        })
        
        task.resume()
    }
}
