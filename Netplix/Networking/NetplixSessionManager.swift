//
//  NetplixSessionManager.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

public class NetplixSessionManager {
    let session : URLSession
    let urlCache = URLCache.shared
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        sessionConfig.urlCache = urlCache
        session = URLSession(configuration: sessionConfig)
    }
    
    func startRequest(with url: URL, method: RequestMethod, parameters: [String:Any]?, headers: [String:String]?, completed: @escaping (Bool, Data?, Error?) -> Void) -> Void {
        var urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        urlRequest.httpMethod = method.rawValue
        if let header = headers {
            for (key, value) in header {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method.rawValue == "GET" {
            guard urlRequest.url != nil else {
                completed(false, nil, self.errorSessionTask())
                return
            }
        } else {
            urlRequest.httpBody = query(parameters ?? [String:String]()).data(using: .utf8, allowLossyConversion: false)
            
            // custom with json object
            guard let params = parameters else { return }
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: (params), options: .prettyPrinted)
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completed(false, data, error)
            } else if let response = response as? HTTPURLResponse, response.statusCode >= 400 {
                completed(false, data, self.errorSessionTask())
            } else {
                completed(false, data, nil)
            }
        }
        
        task.resume()
    }
    
    private func errorSessionTask() -> NSError {
        let userInfo: [String : Any] = [
            NSLocalizedDescriptionKey :  "Error request",
            NSLocalizedFailureReasonErrorKey : "Error requesting from Server"
        ]
        
        let error = NSError(domain: "BALWeatherError", code: 520, userInfo: userInfo)
        return error
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        //NOTE:
        // because the server example by default is not using RFC3986
        // so we don't need to show the 'key' param and preceeded with '?'
        // ref : https://tools.ietf.org/html/rfc3986#section-3
        
        return components.map { "\($1)" }.joined(separator: "")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        components.append((key, "\(value)"))
        return components
    }
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
}

public let netplixSession = NetplixSessionManager()
