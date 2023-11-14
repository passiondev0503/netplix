//
//  HomeInteractor.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

final class HomeInteractor: IHomeInteractor {
    var service: INetplixService!
    var viewModel: NetplixViewModel = NetplixViewModel()
    weak var delegate: HomeInteractorDelegate?
    let dispatchGroup = DispatchGroup()
    var errorAPI: NSError?
    
    func fetchMovieList() {
        fetchMoviePlayingNow()
        fetchMovieUpcoming()
        fetchMovieTopRated()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.delegate?.movieListAPICallGroupFulfill(model: self.viewModel, error: self.errorAPI)
        }
    }

}

private extension HomeInteractor {
    func fetchMoviePlayingNow() {
        dispatchGroup.enter()
        service.getMovieNowPlaying { [weak self] movie in
            self?.viewModel.movieNowPlaying = movie
            self?.dispatchGroup.leave()
        } failure: { [weak self] error in
            self?.errorAPI =  error
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchMovieUpcoming() {
        dispatchGroup.enter()
        service.getMovieUpcoming { [weak self] movie in
            self?.viewModel.movieUpcoming = movie
            self?.dispatchGroup.leave()
        } failure: { [weak self] error in
            self?.errorAPI = error
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchMovieTopRated() {
        dispatchGroup.enter()
        service.getMovieTopRated { [weak self] movie in
            self?.viewModel.movieTopRated = movie
            self?.dispatchGroup.leave()
        } failure: { [weak self] error in
            self?.errorAPI = error
            self?.dispatchGroup.leave()
        }
    }
    
}
