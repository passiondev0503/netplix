//
//  MovieDetailPresenter.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import Foundation

final class MovieDetailPresenter: IMovieDetailPresenter {
    
    weak var view: IMovieDetailView?
    let interactor: IMovieDetailInteractor
    let wireframe: IMovieDetailWireframe
    let reachability: Reachability
    var viewModel: MovieDetailViewModel = MovieDetailViewModel()
    
    init(interactor: IMovieDetailInteractor, wireframe: IMovieDetailWireframe, reachability: Reachability) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.reachability = reachability
    }
    
    func fetchMovieDetail() {
        guard isConnectedToNetwork else {
            wireframe.showAlertNoInternet(retryAction: {[weak self] _ in
                self?.view?.hideLoading()
                self?.fetchMovieDetail()
            }, dismissAction: { [weak self] _ in
                self?.view?.hideLoading()
            })
            return
        }
        view?.showLoading()
        interactor.fetchMovieDetail()
    }
    
    func presentTrailer(url: URL) {
        wireframe.presentTrailer(url: url)
    }
}

extension MovieDetailPresenter {
    var isConnectedToNetwork: Bool {
        return reachability.isConnectedToNetwork()
    }
}

extension MovieDetailPresenter: MovieDetailInteractorDelegate {
    func movieDetailDidSuccess(model: MovieDetailViewModel) {
        self.viewModel = model
        view?.hideLoading()
        view?.update()
    }
    
    func movieDetailDidFail(error: NSError?) {
        if error != nil {
            wireframe.showErrorAlert(retryAction: {[weak self] _ in
                self?.view?.hideLoading()
                self?.fetchMovieDetail()
            }, dismissAction: { [weak self] _ in
                self?.view?.hideLoading()
            })
        }
    }
    
}
