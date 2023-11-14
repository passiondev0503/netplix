//
//  MovieDetailWireframe.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import Foundation
import UIKit
import WebKit

final class MovieDetailWireframe: IMovieDetailWireframe {
    weak var controller: UIViewController?
    let resolver: NetplixResolver
    
    init(resolver: NetplixResolver) {
        self.resolver = resolver
    }
    
    func push(in navigationController: UINavigationController, movieId: Int) {
        let service = resolver.resolve(INetplixService.self)
        let reachbility = resolver.resolve(Reachability.self)
        let interactor = MovieDetailInteractor()
        interactor.service = service
        interactor.movieId = movieId
        let presenter = MovieDetailPresenter(interactor: interactor, wireframe: self, reachability: reachbility)
        let viewController = MovieDetailViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.delegate = presenter
        
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.addChildView(viewController.view)
        controller = vc
        navigationController.present(vc, animated: false)
    }
    
    func showAlertNoInternet(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "You are offline", message: "Check your connection and try again.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .cancel, handler: retryAction)
        alertController.addAction(retryAction)
        let okAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: dismissAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.controller?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showErrorAlert(retryAction: ((UIAlertAction) -> Void)?, dismissAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Error", message: "Please try again later.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .cancel, handler: retryAction)
        alertController.addAction(retryAction)
        let okAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: dismissAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.controller?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentTrailer(url: URL) {
        guard let controller = self.controller else {
            return
        }
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let webViewController = UIViewController()
        webViewController.view.backgroundColor = .white
        webViewController.view.addSubview(webView)
    
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewController.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor)
        ])
    
        controller.present(webViewController, animated: true, completion: nil)
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
}

extension NetplixRouter {
    func pushToMovieDetail(in navigation: UINavigationController, movieId: Int) {
        let wireframe = MovieDetailWireframe(resolver: resolver)
        wireframe.push(in: navigation, movieId: movieId)
    }
}
