//
//  MovieDetailContracts.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import Foundation
import UIKit

protocol IMovieDetailView: AnyObject {
    func showLoading()
    func hideLoading()
    func update()
}

protocol IMovieDetailPresenter: AnyObject {
    var viewModel: MovieDetailViewModel { get }
    func fetchMovieDetail()
    func presentTrailer(url: URL)
}

protocol IMovieDetailInteractor: AnyObject {
    func fetchMovieDetail()
}

protocol IMovieDetailWireframe: AnyObject {
    func showAlertNoInternet(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?)
    func showErrorAlert(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?)
    func presentTrailer(url: URL)
}

protocol MovieDetailInteractorDelegate: AnyObject {
    func movieDetailDidSuccess(model: MovieDetailViewModel)
    func movieDetailDidFail(error: NSError?)
    
}
