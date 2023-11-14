//
//  HomeWireframe.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation
import UIKit

final class HomeWireframe: IHomeWireframe {
    weak var controller: UIViewController?
    let resolver: NetplixResolver
    
    init(resolver: NetplixResolver) {
        self.resolver = resolver
    }
    
    func setupHomeViewController() -> HomeViewController {
        let service = resolver.resolve(INetplixService.self)
        let reachbility = resolver.resolve(Reachability.self)
        let interactor = HomeInteractor()
        interactor.service = service
        let presenter = HomePresenter(interactor: interactor, wireframe: self, reachability: reachbility)
        interactor.delegate = presenter
        let view = HomeViewController()
        view.presenter = presenter
        presenter.view = view
        controller = view
        return view
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
    
    func navigateToMovieDetail(_ movieId: Int) {
        guard let navigationController = controller?.navigationController else { return }
        let router = resolver.resolve(NetplixRouter.self)
        router.pushToMovieDetail(in: navigationController, movieId: movieId)
    }
    

}

extension NetplixRouter {
    func setupHomeViewController() -> HomeViewController {
        let wireframe = HomeWireframe(resolver: resolver)
        return wireframe.setupHomeViewController()
    }
}
