//
//  NetplixAPIs.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

public enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum Encoding: String {
    case url    = "URL"
    case json   = "JSON"
    case plist  = "PLIST"
}

extension NetplixService {
    enum API {
        static func movieNowPlaying() -> String {
            return "now_playing"
        }
        
        static func movieUpcoming() -> String {
            return "upcoming"
        }
        
        static func movieTopRated() -> String {
            return "top_rated"
        }
        
        static func movieDetail(movieId: Int) -> String {
            return "\(movieId)?append_to_response=videos&language=en-US"
        }
    }
}
