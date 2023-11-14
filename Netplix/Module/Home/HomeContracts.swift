//
//  HomeContracts.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation
import UIKit

protocol IHomeView: AnyObject {
    func showLoading()
    func hideLoading()
    func update()
}

protocol IHomePresenter: AnyObject {
    var viewModel: NetplixViewModel { get }
    var movieFiltered: [ResultTopRated] { get }
    func fetchMovieList()
    func search(_ searchText: String)
    func navigateToMovieDetail(_ movieId: Int)
}

protocol IHomeInteractor: AnyObject {
    func fetchMovieList()
}

protocol IHomeWireframe: AnyObject {
    func showAlertNoInternet(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?)
    func showErrorAlert(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?)
    func navigateToMovieDetail(_ movieId: Int)
}

protocol HomeInteractorDelegate: AnyObject {
    func movieListAPICallGroupFulfill(model: NetplixViewModel, error: NSError?)
}
