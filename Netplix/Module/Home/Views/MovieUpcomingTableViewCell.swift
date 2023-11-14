//
//  MovieUpcomingTableViewCell.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

protocol MovieUpcomingTableViewCellDelegate: AnyObject {
    func didSelectMovieUpcoming(movieId: Int)
}
class MovieUpcomingTableViewCell: UITableViewCell {

    private lazy var view = setupMovieUpcomingView()
    weak var delegate: MovieUpcomingTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with model: MovieUpcoming) {
        view.setup(with: model.results)
    }

}

private extension MovieUpcomingTableViewCell {
    
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
    
    func setupMovieUpcomingView() -> MovieUpcomingView {
        let view = MovieUpcomingView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension MovieUpcomingTableViewCell: MovieUpcomingViewDelegate {
    func didSelect(movieId: Int) {
        delegate?.didSelectMovieUpcoming(movieId: movieId)
    }
}

