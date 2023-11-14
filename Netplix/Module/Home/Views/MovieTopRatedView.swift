//
//  MovieTopRatedView.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

protocol MovieTopRatedViewDelegate: AnyObject {
    func didSelect(movieId: Int)
}

class MovieTopRatedView: UIView {
    private lazy var collectionView: UICollectionView = setupCollectionView()

    private var model: [ResultTopRated] =  [ResultTopRated]()
    var isSearch: Bool = false
    let layout = UICollectionViewFlowLayout()
    weak var delegate: MovieTopRatedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: [ResultTopRated]) {
        isSearch = false
        self.model = model
        collectionView.reloadData()
    }
    
    func setupSearch(with model: [ResultTopRated]) {
        isSearch = true
        self.model = model
        layout.scrollDirection = .vertical
        collectionView.reloadData()
    }
}

private extension MovieTopRatedView {
    func setupViews() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupCollectionView() -> UICollectionView {
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieTopRatedCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }
}

extension MovieTopRatedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieTopRatedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        guard let result = model[safe: indexPath.row]  else {
            return cell
        }
        cell.setup(with: result)
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        if isSearch {
            let width = (collectionView.frame.width - 32) / 2 // Adjust for insets
            let height: CGFloat = 250
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 180, height: 250)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = model[safe: indexPath.item]?.id {
            delegate?.didSelect(movieId: movieId)
        }
    }
}
