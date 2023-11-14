//
//  MovieTopRatedTableViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

protocol MovieTopRatedTableViewCellDelegate: AnyObject {
    func didSelectMovieTopRated(movieId: Int)
}

class MovieTopRatedTableViewCell: UITableViewCell {

    private lazy var view = setupMovieTopRatedView()
    weak var delegate: MovieTopRatedTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with model: MovieTopRated) {
        view.setup(with: model.results)
    }
    
    func setup(with movie: [ResultTopRated]) {
        view.setupSearch(with: movie)
    }
}

private extension MovieTopRatedTableViewCell {
    
    func setupViews() {
        contentView.addSubview(view)
        view.delegate = self
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setupMovieTopRatedView() -> MovieTopRatedView {
        let view = MovieTopRatedView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension MovieTopRatedTableViewCell: MovieTopRatedViewDelegate {
    func didSelect(movieId: Int) {
        delegate?.didSelectMovieTopRated(movieId: movieId)
    }
}
