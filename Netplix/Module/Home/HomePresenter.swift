//
//  HomePresenter.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

final class HomePresenter: IHomePresenter {
    
    weak var view: IHomeView?
    let interactor: IHomeInteractor
    let wireframe: IHomeWireframe
    let reachability: Reachability
    var viewModel: NetplixViewModel = NetplixViewModel()
    var movieFiltered: [ResultTopRated] = [ResultTopRated]()
    
    init(interactor: IHomeInteractor, wireframe: IHomeWireframe, reachability: Reachability) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.reachability = reachability
    }
    
    func fetchMovieList() {
        guard isConnectedToNetwork else {
            wireframe.showAlertNoInternet(retryAction: {[weak self] _ in
                self?.view?.hideLoading()
                self?.fetchMovieList()
            }, dismissAction: { [weak self] _ in
                self?.view?.hideLoading()
            })
            return
        }
        view?.showLoading()
        interactor.fetchMovieList()
    }
    
    func search(_ searchText: String) {
        if let model = viewModel.movieTopRated {
            movieFiltered = model.results.filter({ (movie) -> Bool in
                let tmp: NSString = movie.title as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
    }
    
    func navigateToMovieDetail(_ movieId: Int) {
        wireframe.navigateToMovieDetail(movieId)
    }
}

extension HomePresenter {
    var isConnectedToNetwork: Bool {
        return reachability.isConnectedToNetwork()
    }
}

extension HomePresenter: HomeInteractorDelegate {
    func movieListAPICallGroupFulfill(model: NetplixViewModel, error: NSError?) {
        self.viewModel = model
        view?.hideLoading()
        view?.update()
    }
}
