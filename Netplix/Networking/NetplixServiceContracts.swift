//
//  NetplixServiceContracts.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

protocol INetplixService {
    func getMovieNowPlaying(success: @escaping (MovieNowPlaying) -> (), failure: @escaping (NSError) -> ())
    func getMovieUpcoming(success: @escaping (MovieUpcoming) -> (), failure: @escaping (NSError) -> ())
    func getMovieTopRated(success: @escaping (MovieTopRated) -> (), failure: @escaping (NSError) -> ())
    func getMovieDetail(movieId: Int, success: @escaping (MovieDetail) -> (), failure: @escaping (NSError) -> ())
}
