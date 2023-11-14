//
//  NetplixService.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

final class NetplixService: INetplixService {
    static let sharedInstance: INetplixService = { _ -> INetplixService in
        return NetplixService()
    }(())
    
    var jsonDecoder: JSONDecoder = { _ -> JSONDecoder in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }(())
    
    init() {
    }

    func getMovieNowPlaying(success: @escaping (MovieNowPlaying) -> (), failure: @escaping (NSError) -> ()) {
        guard let components = URLComponents(string: Config.BASE_URL + API.movieNowPlaying()) else {
            return
        }
        
        guard
            let url = components.url
        else {
            return
        }
        executeRequest(.get, url: url, parameters: nil, headers: getCommonHeaders()) { response in
            success(response)
        } failure: { isCache, error in
            failure(error)
        }
    }
    
    func getMovieUpcoming(success: @escaping (MovieUpcoming) -> (), failure: @escaping (NSError) -> ()) {
        guard let components = URLComponents(string: Config.BASE_URL + API.movieUpcoming()) else {
            return
        }
        
        guard
            let url = components.url
        else {
            return
        }
        executeRequest(.get, url: url, parameters: nil, headers: getCommonHeaders()) { response in
            success(response)
        } failure: { isCache, error in
            failure(error)
        }
    }
    
    func getMovieTopRated(success: @escaping (MovieTopRated) -> (), failure: @escaping (NSError) -> ()) {
        guard let components = URLComponents(string: Config.BASE_URL + API.movieTopRated()) else {
            return
        }
        
        guard
            let url = components.url
        else {
            return
        }
        executeRequest(.get, url: url, parameters: nil, headers: getCommonHeaders()) { response in
            success(response)
        } failure: { isCache, error in
            failure(error)
        }
    }
    
    func getMovieDetail(movieId: Int, success: @escaping (MovieDetail) -> (), failure: @escaping (NSError) -> ()) {
        guard let components = URLComponents(string: Config.BASE_URL + API.movieDetail(movieId: movieId)) else {
            return
        }
        
        guard
            let url = components.url
        else {
            return
        }
        executeRequest(.get, url: url, parameters: nil, headers: getCommonHeaders()) { response in
            success(response)
        } failure: { isCache, error in
            failure(error)
        }
    }
}

private extension NetplixService {
    func executeRequest<T: Decodable>(_ method: RequestMethod, url: URL, parameters: [String: Any]?, headers: [String: String]?, success: @escaping (T) -> Void, failure: @escaping (Bool, NSError) -> Void) {
        netplixSession.startRequest(with: url, method: method, parameters: parameters, headers: headers) { (isCache, data, error) in
            guard
                let response = data, let result = try? self.jsonDecoder.decode(T.self, from: response)
            else {
                failure(isCache, NSError(domain: "NetplixService", code: -1, userInfo: ["error": error as Any]))
                return
            }
            DispatchQueue.main.async {
                success(result)
            }
        }
    }
    
    private func getCommonHeaders() -> [String: String] {
        return  [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMDY0YjkxMDczYzg4Njg5ZTQwOWFmMGU5MTViMWQyOSIsInN1YiI6IjY1NGRjMWRiNDFhNTYxMzM2YjdhYmY5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.DGzxCVqAHuC42BTyfp_mJ2CIQilySpnA5Hrb-7BJmH4"
        ]
    }
}
