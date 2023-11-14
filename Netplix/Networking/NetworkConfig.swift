//
//  NetworkConfig.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

struct Config {
    static let PACKAGE_NAME = "com.xsis.Netplix"
    static let BASE_URL: String = {
        return "https://api.themoviedb.org/3/movie/"
    }()
    
}
