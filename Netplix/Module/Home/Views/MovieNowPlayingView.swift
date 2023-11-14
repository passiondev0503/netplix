//
//  MovieNowPlayingView.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import UIKit

protocol MovieNowPlayingViewDelegate: AnyObject {
    func didSelect(movieId: Int)
}

class MovieNowPlayingView: UIView {
    
    private lazy var collectionView: UICollectionView = setupCollectionView()
    private lazy var pageControl: UIPageControl = setupPageControl()
    private var model: [ResultNowPlaying] =  [ResultNowPlaying]()
    weak var delegate: MovieNowPlayingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: [ResultNowPlaying]) {
        self.model = model
        pageControl.numberOfPages = model.count
        pageControl.currentPage = 0
        collectionView.reloadData()
    }
}

private extension MovieNowPlayingView {
    func setupViews() {
        addSubview(collectionView)
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            pageControl.heightAnchor.constraint(equalToConstant: 24),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(MovieNowPlayingCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }
    
    func setupPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        return pageControl
    }
}

extension MovieNowPlayingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieNowPlayingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        guard let result = model[safe: indexPath.row]  else {
            return cell
        }
        cell.setup(with: result)
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = model[safe: indexPath.item]?.id {
            delegate?.didSelect(movieId: movieId)
        }
    }
}
