//
//  MovieNowPlayingTableViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

protocol MovieNowPlayingTableViewCellDelegate: AnyObject {
    func didSelectMovieNowPlaying(movieId: Int)
}
class MovieNowPlayingTableViewCell: UITableViewCell {
    private lazy var view = setupMovieNowPlayingView()
    weak var delegate: MovieNowPlayingTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with model: MovieNowPlaying) {
        view.setup(with: model.results)
    }
    
}
private extension MovieNowPlayingTableViewCell {
    
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
    
    func setupMovieNowPlayingView() -> MovieNowPlayingView {
        let view = MovieNowPlayingView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension MovieNowPlayingTableViewCell: MovieNowPlayingViewDelegate {
    func didSelect(movieId: Int) {
        delegate?.didSelectMovieNowPlaying(movieId: movieId)
    }
}
