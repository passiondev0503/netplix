//
//  MovieDetailInteractor.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import Foundation

final class MovieDetailInteractor: IMovieDetailInteractor {
    var service: INetplixService!
    var viewModel: MovieDetailViewModel = MovieDetailViewModel()
    var movieId: Int?
    weak var delegate: MovieDetailInteractorDelegate?
  
    func fetchMovieDetail() {
        guard let movieId = self.movieId else {
            return
        }
        print("Movie ID: \(movieId)")
        service.getMovieDetail(movieId: movieId) { [weak self] movieDetail in
            guard let `self` = self else {
                return
            }
            self.viewModel.movieDetail = movieDetail
            self.delegate?.movieDetailDidSuccess(model: self.viewModel)
        } failure: { [weak self] error in
            self?.delegate?.movieDetailDidFail(error: error)
        }

    }
}
