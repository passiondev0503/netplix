//
//  MovieDetailViewController.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

final class MovieDetailViewController: BaseUIViewController {
    var presenter: IMovieDetailPresenter!
    let containerView = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie Detail"
        presenter.fetchMovieDetail()
        
        let oneThirdScreenHeight = UIScreen.main.bounds.height / 3

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = .lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        
      
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        // Create the play icon
        let playSymbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        let playSymbol = UIImage(systemName: "play.fill", withConfiguration: playSymbolConfig)
        
        let playIcon = UIImageView(image: playSymbol)
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        playIcon.tintColor = .white
        playIcon.alpha = 0.8

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16) // Set your desired font
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
      
        containerView.addSubview(imageView)
        containerView.addSubview(playIcon)
        
        view.addSubview(containerView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
    
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            playIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: oneThirdScreenHeight),
            titleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    @objc func containerViewTapped() {
        guard let model = presenter.viewModel.movieDetail else {
            return
        }
        if let video = model.videos.results.first(where: {$0.type == "Trailer"}), let url = URL(string: "https://www.youtube.com/embed/\(video.key)") {
            presenter.presentTrailer(url: url)
        }
        
    }
}

extension MovieDetailViewController: IMovieDetailView {
    
    func showLoading() {
        startLoading(isHidden: false)
    }
    
    func hideLoading() {
        startLoading(isHidden: true)
    }
    
    func update() {
        guard let model = presenter.viewModel.movieDetail else {
            return
        }
        imageView.setImage(with: model.backdropPath)
        titleLabel.text = model.originalTitle
        subtitleLabel.text = model.overview
    }
}

