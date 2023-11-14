//
//  NetplixViewModel.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

class NetplixViewModel: Codable {
    
    var movieNowPlaying: MovieNowPlaying?
    var movieUpcoming: MovieUpcoming?
    var movieTopRated: MovieTopRated?
    
    init() {}
}
